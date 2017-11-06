
import java.util.HashMap;
import org.apache.poi.util.HexDump;
import java.nio.*;

/**
 *  Description of the Class
 *
 *@author     Paul Nguyen
 *@created    April 29, 2003
 */
public class Util {

	private static byte[][] pool ;
	private static int pool_cnt = -1 ;
	private static int pool_size = 1024*10 ;


	private static void fillPool() {
		pool_cnt = 0 ;
		for (int i=0; i<pool_size; i++) {
			 RandomGUID guid = new RandomGUID() ;
			 //System.out.print( "GUID Generated: " + Util.toHexString(guid.getBytes()) ) ;
			 //System.out.println( " [GUID Length: " + guid.getBytes().length + "]" ) ;  
			byte[] guid_bytes = guid.getBytes()  ;
			pool[i] = guid_bytes ;
		}
	}


  /**
   *  Description of the Method
   *
   *@param  value  Description of Parameter
   *@return        Description of the Returned Value
   *@since
   */
  public static String toHexString(byte[] value) {
    String hexstr = "";

    if ( value == null )
	    return hexstr ;

    for (int i = 0; i < value.length; i++) {
      hexstr += HexDump.toHex(value[i]);
      if (i < value.length - 1) {
        hexstr += ".";
      }
    }
    return hexstr;
  }

  public static byte[] generateGUID() {

    //RandomGUID guid = new RandomGUID() ;
    //System.out.print( "GUID Generated: " + Util.toHexString(guid.getBytes()) ) ;
    //System.out.println( " [GUID Length: " + guid.getBytes().length + "]" ) ;  
    //return guid.getBytes() ;

    if ( pool_cnt < 0 ) {
	     //System.out.println( "Loading Pool of GUID's... (Pool Count=" + pool_size + ")" ) ;
		pool = new byte[pool_size][32] ; // 32 bytes GUID
		fillPool() ;
    }
    else if ( pool_cnt == pool_size ) {
	    fillPool() ;
    }

    return pool[pool_cnt++] ;

  }
  
  public static String toStringGUID( byte[] guid ) {
    if ( guid == null )
	    return "" ;
    return Util.toHexString(guid) ;
  }
  
}

