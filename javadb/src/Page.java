
import java.util.*;
import org.apache.poi.util.HexDump;
import java.nio.*;

/**
 *  Description of the Class
 *
 *@author     Paul Nguyen
 *@created    April 29, 2003
 */
public class Page {

	private final static boolean DEBUG = true;
	private final static int LARGE_RECORD_FLAG = 998718892;
	private ByteBuffer pagebuffer;
	private ByteBuffer slottable;
	private int page_hdr_size;// 4 bytes - # of bytes for header
	private int page_number;// 4 bytes - identifies page
	private int page_size;// 4 bytes - # of bytes in page
	private int vol_id;// volume page is in
	private Volume vol;// ref to volume

	private Hashtable simple_record_cache = new Hashtable();


	/**
	 *  Constructor for the Page object
	 *
	 *@param  buffer    Description of Parameter
	 *@param  vol       Description of Parameter
	 *@since
	 */
	public Page(ByteBuffer buffer, Volume vol) {

		// save volume ref
		this.vol = vol;

		// setup and load header
		this.vol_id = vol.getVolumeId();
		this.pagebuffer = buffer.duplicate();
		this.page_hdr_size = pagebuffer.getInt();
		this.page_number = pagebuffer.getInt();
		this.page_size = pagebuffer.getInt();

		// setup slot table buffer
		int slot_table_offset = 5 * 4;// go pass 5 ints in header
		int slot_table_byte_size = Device.NUM_BLOCKS_PER_PAGE * 4;// 512 slots, 4 bytes each
		this.pagebuffer.position(slot_table_offset).limit(slot_table_byte_size);
		this.slottable = this.pagebuffer.slice();
		this.slottable.putInt(slot_table_byte_size);

	}



	/*
	 *  volume this page belongs to
	 */
	/**
	 *  Constructor for the setVolumeId object
	 *
	 *@param  value  Description of Parameter
	 *@since
	 */
	//public void setVolumeId(int value) {
	//	this.vol_id = value;
	//}// simple page cache for lookups


	/**
	 *  Gets the pageNumber attribute of the Page object
	 *
	 *@return    The pageNumber value
	 *@since
	 */
	public int getPageNumber() {
		return this.page_number;
	}


	/**
	 *  Create a RecordSetIterator, initialized it, and return it
	 *
	 *@return
	 *@since
	 */
	public RecordSetIterator getRecordSetIterator() {
		return
			new RecordSetIterator() {

				private Hashtable records = new Hashtable();
				private Object[] keyset = null;
				private int keyindex = 0;


				public byte[] getNextRecord() {
					String key = (String) keyset[keyindex++];
					byte[] keybytes = (byte[]) records.get(key);
					return getRecord(keybytes);
				}


				public void reset() {
					records.clear();
					slottable.clear();
					slottable.getInt();// skip slot 0 (size)
					for (int i = 1; i < (slottable.limit() / 4); i++) {
						int slotvalue = slottable.getInt();
						if (slotvalue != 0) {
							ByteBuffer rec_id = ByteBuffer.allocate(8);
							rec_id.putInt(vol_id);
							rec_id.putShort((short) page_number);
							rec_id.putShort((short) slotvalue);
							byte[] rec_id_bytes = rec_id.array();
							records.put(Util.toHexString(rec_id_bytes), rec_id_bytes);
							if (DEBUG) {
								System.out.println("Record Iterator: Slot # " + i + " = " + slotvalue);
								System.out.println("Record Iterator: Key Added: " + Util.toHexString(rec_id_bytes));
							}
						}
					}
					keyset = records.keySet().toArray();
					keyindex = 0;
					if (DEBUG) {
						dumpState();
					}
				}


				public boolean hasMoreRecords() {
					return (keyindex < keyset.length);
				}


				private void dumpState() {
					System.out.println("===== RECORD SET ITERATOR =====");
					System.out.println("Num Records:        " + keyset.length);
					System.out.println("Current Index:      " + keyindex);
					System.out.println("Has More Records :  " + (keyindex < keyset.length));
					for (int i = keyindex; i < keyset.length; i++) {
						String key = (String) keyset[i];
						System.out.println("Key[ " + i + " ] = " + key);
					}
					System.out.println("===============================");
				}

			};
	}


	/**
	 *  Gets the record attribute of the Page object
	 *
	 *@param  recid  Description of Parameter
	 *@return        The record value
	 *@since
	 */
	public ByteBuffer getRecordByteBuffer(byte[] recid) {

		try {

			ByteBuffer recid_buf = ByteBuffer.wrap(recid);
			recid_buf.position(6);
			short rec_start_block = recid_buf.getShort();

			// scan for record in slot table
			boolean found = false;
			int rec_block_span = 0;
			this.slottable.clear();
			this.slottable.getInt();// skip slot 0 (size)
			for (int i = 1; i < (this.slottable.limit() / 4); i++) {
				int slotvalue = this.slottable.getInt();
				if (slotvalue == rec_start_block) {
					found = true;
					rec_block_span = 0;
					while (slotvalue == rec_start_block
							 && this.slottable.position() < this.slottable.limit()) {
						rec_block_span++;
						slotvalue = this.slottable.getInt();
					}
					break;
				}
			}
			if (!found) {
				return null;
			}

			if (DEBUG) {
				System.out.println("GET RECORD: " + Util.toHexString(recid));
				System.out.println("RECORD START BLOCK: " + rec_start_block);
				System.out.println("RECORD BLOCK SPAN:  " + rec_block_span);
			}

			// get record block(s)
			ByteBuffer recdata_block = getBlock(rec_start_block, rec_block_span);

			return recdata_block;
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
			return null;
		}
	}


	private byte[] getLargeRecord(byte[] recid) {

		byte[] recdata_bytes ;
	
		try {

			ByteBuffer recdata_block = getRecordByteBuffer(recid);

			if (recdata_block == null) {
				return null;
			}

			int hdrsize = recdata_block.getInt();
			int recsize = recdata_block.getInt();
			int pageid = recdata_block.getInt();
			int pagecnt = recdata_block.getInt();
			int filler = recdata_block.getInt();

			if (DEBUG) {
				System.out.println( "Large Record Data Size: " + recsize ) ; 
				System.out.println( "Large Record Start Page Num: " + pageid ) ; 
				System.out.println( "Large Record Page Count: " + pagecnt ) ; 
			}

			if (DEBUG)
				System.out.println( "Allocating large record buffer..." ) ;

			// TODO:  Piece together record chunks...
			recdata_bytes = new byte[ recsize ] ;

			if (DEBUG)
				System.out.println( "Loading large record data..." + recdata_bytes ) ;

			ByteBuffer pages = vol.getPageBuffer( pageid, pagecnt ) ;
			pages.get(recdata_bytes, 0, recsize);
	

			return recdata_bytes;

		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
			return null;
		}
	
	}

	/**
	 *  Gets the record attribute of the Page object
	 *
	 *@param  recid  Description of Parameter
	 *@return        The record value
	 *@since
	 */
	public byte[] getRecord(byte[] recid) {

		byte[] recdata_bytes = null;

		//recdata_bytes = (byte[]) this.simple_record_cache.get(recid);
		//if (recdata_bytes != null) {
		//	return recdata_bytes;
		//}

		try {

			ByteBuffer recdata_block = getRecordByteBuffer(recid);

			if (recdata_block == null) {
				return null;
			}

			int hdrsize = recdata_block.getInt();
			int recsize = recdata_block.getInt();
			int prevblk = recdata_block.getInt();
			int nextblk = recdata_block.getInt();
			int filler = recdata_block.getInt();

			if (filler == Page.LARGE_RECORD_FLAG) {
				recdata_bytes = getLargeRecord( recid ) ;
			}
			else {			
				if (DEBUG) {
					System.out.println("Hdr Size: " + hdrsize);
					System.out.println("Record Size: " + recsize);
				}
				recdata_bytes = new byte[recsize];
				recdata_block.position(20);
				recdata_block.get(recdata_bytes, 0, recsize);
				if (DEBUG && recdata_bytes.length < 1000) {
					System.out.println("FOUND RECORD (DATA): " + Util.toHexString(recdata_bytes));
				}
			}
			
			return recdata_bytes;

		} catch (Exception e) {
			System.out.println("getRecord() Error: " + e);
			e.printStackTrace();
			return null;
		}
	}


	private byte[] addLargeRecord(byte[] data) throws PageFullException {
		byte[] rec_id_bytes = null;

		try {

			// Find Slot to Insert
			int data_size = data.length;
			int data_block = 0;// starting block
			int block_count = 1;
			if (DEBUG) {
				System.out.println("Need to find " + block_count + " block(s) (FOR LARGE RECORD TABLE)...");
			}
			this.slottable.clear();
			this.slottable.getInt();// skip slot 0 (size)
			int free_contiguous_blocks = 0;
			for (int i = 1; i < ((this.slottable.limit() - 1) / 4); i++) {
				int slotvalue = this.slottable.getInt();
				if (slotvalue == 0) {
					if (data_block == 0) {
						data_block = i;
					}
					free_contiguous_blocks++;
					if (free_contiguous_blocks == block_count) {
						break;
					}
				} else {
					free_contiguous_blocks = 0;
					data_block = 0;
				}
			}
			if (DEBUG) {
				System.out.println("Data Block Found: " + data_block);
				System.out.println("Record Block Size: " + free_contiguous_blocks);
			}

			// todo, throw exception here if no free contiguous blocks found
			// assume at upper layers, allocation of a new page will be done
			if (block_count != free_contiguous_blocks) {
				throw new PageFullException();
			}

			// Update Slot Table
			this.slottable.clear();
			this.slottable.position(data_block * 4);
			for (int count = free_contiguous_blocks; count != 0; count--) {
				this.slottable.putInt(data_block);// record id is start block id in page for record
			}

			// calculate how many pages we need 
			int page_count = (data_size / Device.PAGE_SIZE) + 1 ;

			// get new starting page
			Page start_page = vol.newFreePage() ;
			int page_id = start_page.getPageNumber() ;

			// allocate additional pages to reserve space
			for (int i = 1; i<page_count; i++ )
				vol.newFreePage() ;

			// Get Block and Store Large Record Context
			ByteBuffer block = getBlock(data_block, free_contiguous_blocks);
			block.putInt(20);// 20 bytes header size
			block.putInt(data.length);// record size
			block.putInt(page_id);// Start Page
			block.putInt(page_count);// Num Pages
			block.putInt(Page.LARGE_RECORD_FLAG);// Large Record Flag

			// TODO: chop up bytes into page sized chunks and store them
			// block.put(data); -- for now map directly to pages
			if (DEBUG) {
				System.out.println( "Large Record Data Size: " + data_size ) ; 
				System.out.println( "Large Record Start Page Num: " + page_id ) ; 
				System.out.println( "Large Record Page Count: " + page_count ) ; 
				System.out.println( "Saving large record data..." ) ;
			}
			ByteBuffer pages = vol.getPageBuffer( page_id, page_count ) ;
			pages.put(data);

			// Compute the Record ID and return it
			ByteBuffer rec_id = ByteBuffer.allocate(8);
			rec_id.putInt(this.vol_id);
			rec_id.putShort((short) this.page_number);
			rec_id.putShort((short) data_block);
			rec_id_bytes = rec_id.array();

			if (DEBUG) {
				System.out.println("LARGE RECORD ID: " + Util.toHexString(rec_id_bytes));
			}

			//this.simple_record_cache.put(rec_id_bytes, data);

			return rec_id_bytes;
		} catch (PageFullException pf) {
			throw pf;
		} catch (Exception e) {
			throw new PageFullException();
		}
	}

	/**
	 *  Creates a new record in the page.
	 *
	 *@param  data                   data to be added
	 *@return                        8 byte value for physical record id
	 *@exception  PageFullException  Description of Exception
	 *@since
	 */
	public byte[] addRecord(byte[] data) throws PageFullException {

		if (data.length > Device.PAGE_SIZE ) {
			return addLargeRecord(data) ;
		}

		byte[] rec_id_bytes = null;

		try {

			// Find Slot to Insert
			int data_size = data.length;
			int data_block = 0;// starting block
			int block_count = (data_size / Device.BLOCK_SIZE) + 1;
			if (DEBUG) {
				System.out.println("Need to find " + block_count + " block(s)...");
			}
			this.slottable.clear();
			this.slottable.getInt();// skip slot 0 (size)
			int free_contiguous_blocks = 0;
			for (int i = 1; i < ((this.slottable.limit() - 1) / 4); i++) {
				int slotvalue = this.slottable.getInt();
				if (slotvalue == 0) {
					if (data_block == 0) {
						data_block = i;
					}
					free_contiguous_blocks++;
					if (free_contiguous_blocks == block_count) {
						break;
					}
				} else {
					free_contiguous_blocks = 0;
					data_block = 0;
				}
			}
			if (DEBUG) {
				System.out.println("Data Block Found: " + data_block);
				System.out.println("Record Block Size: " + free_contiguous_blocks);
			}

			// todo, throw exception here if no free contiguous blocks found
			// assume at upper layers, allocation of a new page will be done
			if (block_count != free_contiguous_blocks) {
				throw new PageFullException();
			}

			// Update Slot Table
			this.slottable.clear();
			this.slottable.position(data_block * 4);
			for (int count = free_contiguous_blocks; count != 0; count--) {
				this.slottable.putInt(data_block);// record id is start block id in page for record
			}

			// Get Block and Store
			ByteBuffer block = getBlock(data_block, free_contiguous_blocks);
			block.putInt(20);// 20 bytes header size
			block.putInt(data.length);// record size
			block.putInt(-1);// Prev Block
			block.putInt(-1);// Next Block
			block.putInt(-1);// Filler
			block.put(data);

			// Compute the Record ID and return it
			ByteBuffer rec_id = ByteBuffer.allocate(8);
			rec_id.putInt(this.vol_id);
			rec_id.putShort((short) this.page_number);
			rec_id.putShort((short) data_block);
			rec_id_bytes = rec_id.array();

			if (DEBUG) {
				System.out.println("RECORD ID: " + Util.toHexString(rec_id_bytes));
			}

			//this.simple_record_cache.put(rec_id_bytes, data);

			return rec_id_bytes;
		} catch (PageFullException pf) {
			throw pf;
		} catch (Exception e) {
			throw new PageFullException();
		}
	}


	/**
	 *  Description of the Method
	 *
	 *@param  newdata                Description of Parameter
	 *@param  record_id              Description of Parameter
	 *@return                        Description of the Returned Value
	 *@exception  PageFullException  Description of Exception
	 *@since
	 */
	public byte[] updateRecord(byte[] record_id, byte[] newdata) throws PageFullException {
		deleteRecord(record_id);
		return addRecord(newdata);
	}


	/**
	 *  Description of the Method
	 *
	 *@param  recid  Description of Parameter
	 *@since
	 */
	public void deleteRecord(byte[] recid) {
		ByteBuffer recid_buf = ByteBuffer.wrap(recid);
		recid_buf.position(6);
		short rec_start_block = recid_buf.getShort();
		if (DEBUG) {
			System.out.println("DELETE RECORD: " + Util.toHexString(recid));
			System.out.println("RECORD START BLOCK: " + rec_start_block);
		}
		// scan slot table and clear slot(s) held by record
		this.slottable.clear();
		this.slottable.getInt();// skip slot 0 (size)
		for (int i = 1; i < (this.slottable.limit() / 4); i++) {
			int slotvalue = this.slottable.getInt();
			if (slotvalue == rec_start_block) {
				int curpos = this.slottable.position();
				this.slottable.position(curpos - 4);
				this.slottable.putInt(0);
			}
		}
		//this.simple_record_cache.remove(recid);
	}


	/**
	 *  Description of the Method, NoFreePageException
	 *
	 *@since
	 */
	public void dumpHeader() {
		System.out.println("===== START PAGE HEADER =====");
		System.out.println("Header Size:   " + page_hdr_size + " bytes ");
		System.out.println("Page Number:   " + page_number);
		System.out.println("Page Size:     " + page_size + " bytes ");
		System.out.println("-- Slot Table --");
		this.slottable.clear();
		this.slottable.getInt();// skip slot 0 (size)
		/*
		 *  for (int i = 1; i < (this.slottable.limit() / 4); i++) {
		 *  int slotvalue = this.slottable.getInt();
		 *  if (slotvalue != 0) {
		 *  System.out.println("Slot # " + i + " = " + slotvalue);
		 *  }
		 *  }
		 */
		System.out.println("===== END PAGE HEADER =====");
	}


	/**
	 *  Gets the block attribute of the Page object
	 *
	 *@param  block_number  Description of Parameter
	 *@param  span          Description of Parameter
	 *@return               The block value
	 *@since
	 */
	private ByteBuffer getBlock(int block_number, int span) {
		int offset = Device.BLOCK_SIZE * (block_number);
		int limit = Device.BLOCK_SIZE * span + offset;
		if (DEBUG) {
			System.out.println("Get Page Block Number: " + block_number);
			System.out.println("Get Page Block Offset: " + offset);
			System.out.println("Get Page Block Limit: " + limit);
		}
		if (DEBUG) {
			System.out.println("Page Buffer: " + this.pagebuffer);
		}
		this.pagebuffer.clear();
		this.pagebuffer.position(offset).limit(limit);
		ByteBuffer block = this.pagebuffer.slice();
		if (DEBUG) {
			System.out.println("Got Page Block: " + block);
		}
		return block;
	}

	/*
	 *  #Record lnkRecord;
	 */
}

