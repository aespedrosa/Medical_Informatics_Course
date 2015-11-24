package main;

import java.io.File;
import java.util.Iterator;
import java.util.Vector;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;

import fr.apteryx.imageio.dicom.DicomReader; 
import fr.apteryx.imageio.dicom.FileSet; 
import fr.apteryx.imageio.dicom.Tag; 
import fr.apteryx.imageio.dicom.Plugin;

public class ReadDicomDir {
        
    public ReadDicomDir(){

    	Plugin.setLicenseKey("NM73KIZUPKHLFLAQM5L0V9U"); 
       
    }
    
    public Vector<Vector<Object>> readDirectory(String path, Vector<Atributes> atributosExames, Vector<File> filesExames) throws Exception {
       
    	Vector<Vector<Object>> results = new Vector<Vector<Object>>();
    	
    	ImageIO.scanForPlugins();
        
        Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("DICOM");
        DicomReader reader = (DicomReader) readers.next();
        
        FileSet rootDir = new FileSet(new File(path + "/DICOMDIR"), reader);
    	
        FileSet.Directory patientDir = rootDir.getRootDirectory();
        
    	for (int p_index=0 ; p_index<patientDir.getNumRecords() ; p_index++){
    		
    		FileSet.Directory studyDir = patientDir.getRecord(p_index).getLowerLevelDirectory();
    		
    		for (int st_index=0 ; st_index<studyDir.getNumRecords() ; st_index++){
    			
    			FileSet.Directory seriesDir = studyDir.getRecord(st_index).getLowerLevelDirectory();
    			
    			for (int se_index=0 ; se_index<seriesDir.getNumRecords() ; se_index++){
        			
    				FileSet.Directory imageDir = seriesDir.getRecord(se_index).getLowerLevelDirectory();
    				
    				for (int i_index=0 ; i_index<imageDir.getNumRecords() ; i_index++){
    					
    					if ( imageDir.getRecord(i_index).getType().equals("IMAGE") ) {
    						
    						Vector<Object> temp = new Vector<Object>();
    						
    						temp.addElement(seriesDir.getRecord(se_index).getAttribute(Tag.Modality));
    						temp.addElement(patientDir.getRecord(p_index).getAttribute(Tag.PatientID));
    						temp.addElement(patientDir.getRecord(p_index).getAttribute(Tag.PatientsBirthDate));
    						temp.addElement(patientDir.getRecord(p_index).getAttribute(Tag.PatientsName));
    						
    						results.addElement(temp);
    						
    						Atributes att = new Atributes(patientDir.getRecord(p_index).getAttributes() , 
                					studyDir.getRecord(st_index).getAttributes() , 
                					seriesDir.getRecord(se_index).getAttributes() ,
                					imageDir.getRecord(i_index).getAttributes()
                					);
    						
    						atributosExames.addElement(att);
    						
    						filesExames.addElement(imageDir.getRecord(i_index).getFile());
    						
    					}
    				}			
        		}
    		}
    	}
    	
        return results;
    }

}
