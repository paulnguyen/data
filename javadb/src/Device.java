
import java.nio.channels.FileChannel;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.BufferOverflowException;
import java.io.File;
import java.io.RandomAccessFile;

import java.util.*;

/**
 *  Description of the Class
 *
 *@author     Paul Nguyen
 *@created    April 24, 2003
 */
public class Device {

  /**
   *  Description of the Field
   *
   *@since
   */
  public final static int NUM_BLOCKS_PER_PAGE = 512;  // 512 blocks per page

  /**
   *  Description of the Field
   *
   *@since
   */
  public final static int BLOCK_SIZE = 8 * 1024;// 8K blocks
  /**
   *  Description of the Field
   *
   *@since
   */
  public final static int PAGE_SIZE = BLOCK_SIZE * NUM_BLOCKS_PER_PAGE;

  private final static boolean DEBUG = true;

  private String filename;
  private FileChannel filechannel;
  private MappedByteBuffer bytebuffer;
  


  /**
   *  Constructor for the Device object
   *
   *@param  filename  Description of Parameter
   *@since
   */
  public Device(String filename) {
    this.filename = filename;
    this.filechannel = null;
    this.bytebuffer = null;
  }


  /**
   *  Gets the block attribute of the Device object
   *
   *@param  block_number  Description of Parameter
   *@return               The block value
   *@since
   */
  public ByteBuffer getBlock(int block_number) {
    allocateByteBuffer();
    int offset = BLOCK_SIZE * (block_number);
    int limit = BLOCK_SIZE + offset;
    if (DEBUG) {
      System.out.println("Get Block Number: " + block_number);
      System.out.println("Get Block Offset: " + offset);
      System.out.println("Get BLock Limit: " + limit);
    }
    this.bytebuffer.position(offset).limit(limit);
    ByteBuffer block = this.bytebuffer.slice();
    return block;
  }


  /**
   *  Gets the page attribute of the Device object
   *
   *@param  page_number  Description of Parameter
   *@return              The page value
   *@since
   */
  public ByteBuffer getPage(int page_number) {
    allocateByteBuffer(page_number);
    int offset = PAGE_SIZE * (page_number);
    offset += BLOCK_SIZE;
    // for file header
    int limit = offset + PAGE_SIZE;
    if (DEBUG) {
      System.out.println("Get Page Number: " + page_number);
      System.out.println("Get Page Offset: " + offset);
      System.out.println("Get Page Limit: " + limit);
    }
    this.bytebuffer.position(offset).limit(limit);
    ByteBuffer page = this.bytebuffer.slice();
    return page;
  }


  public ByteBuffer getLargePages(int page_number, int page_count) {
    allocateByteBuffer(page_number);
    int offset = PAGE_SIZE * (page_number);
    int limit = offset + (PAGE_SIZE*page_count);
    if (DEBUG) {
      System.out.println("Get Large Page Start Page Number: " + page_number);
      System.out.println("Get Large Page Offset: " + offset);
      System.out.println("Get Large Page Limit: " + limit);
    }
    this.bytebuffer.position(offset).limit(limit);
    ByteBuffer page = this.bytebuffer.slice();
    return page;
  }



  /**
   *  Gets the channel attribute of the Device object
   *
   *@return    The channel value
   *@since
   */
  public FileChannel getChannel() {
    return filechannel;
  }


  /**
   *  Description of the Method
   *
   *@return    Description of the Returned Value
   *@since
   */
  public boolean mount() {
    try {

      File filechk = new File(this.filename);

      if (filechk.exists()) {
        if (DEBUG) {
          System.out.println(this.filename + " exists.");
        }
        RandomAccessFile thefile = new RandomAccessFile(this.filename, "rw");
        this.filechannel = thefile.getChannel();
        return false;
      } else {
        if (DEBUG) {
          System.out.println(this.filename + " does not exist, creating...");
        }
        RandomAccessFile thefile = new RandomAccessFile(this.filename, "rw");
        thefile.setLength(BLOCK_SIZE + PAGE_SIZE);
        // one block header + initial page
        this.filechannel = thefile.getChannel();
        return true;
      }
    } catch (Exception e) {
      System.out.println(e);
      return false;
    }
  }


  /**
   *  Description of the Method
   *
   *@since
   */
  public void umount() {
    if (this.bytebuffer != null) {
      this.bytebuffer.force();
    }
  }


  /**
   *  Description of the Method
   *
   *@since
   */
  private void allocateByteBuffer() {

    try {
      if (DEBUG) {
        System.out.println("File Channel Size: " + this.filechannel.size());
      }
      if (this.bytebuffer == null) {
        this.bytebuffer = this.filechannel.map(
            FileChannel.MapMode.READ_WRITE,
            0,
            this.filechannel.size()
            );
        this.bytebuffer.clear();
      } else {
        this.bytebuffer.clear();
      }
    } catch (Exception e) {
    }
  }


  /**
   *  Description of the Method
   *
   *@param  page_number  Description of Parameter
   *@since
   */
  private void allocateByteBuffer(int page_number) {

    int offset = PAGE_SIZE * (page_number) + BLOCK_SIZE ;
    int limit = offset + PAGE_SIZE;

    try {
      
      if (DEBUG) {
        System.out.println("File Channel Size: " + this.filechannel.size());
        System.out.println("Page Request Size: " + limit );        
      }
      
      // map to full file
      if (this.bytebuffer == null) {
        this.bytebuffer = this.filechannel.map(
            FileChannel.MapMode.READ_WRITE,
            0,
            this.filechannel.size()
            );
      } 
      
      // todo, check for max extent limit and throw exception      
      // expand fize size to accomodate page expansion       
      if (limit > this.filechannel.size() ) {
        this.bytebuffer = this.filechannel.map(
            FileChannel.MapMode.READ_WRITE,
            0,
            limit
            );        
      }
      
      this.bytebuffer.clear();
    } catch (Exception e) {
    }
  }


}

