
/**
 *  Description of the Class
 *
 *@author     Paul Nguyen
 *@created    April 29, 2003
 */
public class Record extends SM.Record {

  private int rec_hdr;// 4 bytes - # bytes for record header
  private int rec_size; // 4 bytes - # bytes for record data
  private int rec_next_block_id;// 4 bytes - next block within page for record data
  private int rec_prev_block_id;// 4 bytes - prev block within page for record data
  private int rec_type; // 4 bytes - record type


  /**
   *  Constructor for the Record object
   *
   *@param  size  Description of Parameter
   *@since
   */
  public Record(int size) throws SM.SMException {
      super(size);
  }


  /**
   *  Gets the bytes attribute of the Record object
   *
   *@return    The bytes value
   *@since
   */
  public byte[] getBytes() {
    return super.getBytes(0, 0);
  }


  /**
   *  Description of the Method
   *
   *@since
   */
  private void readRecordHeader() { }

}

