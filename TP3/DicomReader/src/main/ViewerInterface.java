package main;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.FileImageInputStream;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import fr.apteryx.imageio.dicom.DicomMetadata;
import fr.apteryx.imageio.dicom.DicomReader;

public class ViewerInterface implements Runnable {

	private Thread thread;
	private JFrame frame;
	private JPanel contentPanel;
	private JPanel buttonPanel;
	private JPanel imagePanel;
	private JLabel frameLabel;
	private int frameIndex;
	private int framesNumber;
	private long frameTime;
	private DicomMetadata dmd;

	private boolean pause;

	private DicomReader dicomReader;

	public ViewerInterface(File imageFile , long frametime) throws FileNotFoundException, IOException {

		thread = new Thread(this);

		Iterator<ImageReader> readers = ImageIO.getImageReadersByFormatName("DICOM");
		dicomReader = (DicomReader) readers.next();

		dicomReader.setInput(new FileImageInputStream(imageFile));

		frameIndex = 0;

		framesNumber = dicomReader.getNumImages(true);
		frameTime = frametime;

		initializeInterface();

		pause = true;
		thread.start();
	}

	/**
	 * Initialize the contents of the frame.
	 * @throws IOException 
	 */
	private void initializeInterface() throws IOException {
		frame = new JFrame();

		frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
	
		contentPanel = new JPanel();
		contentPanel.setLayout(new BorderLayout());

		imagePanel = imagePanelCreator(0);

		buttonPanel = new JPanel();

		JButton playButton = new JButton("Play");
		playButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pause = false;
			}
		});

		JButton pauseButton = new JButton("Pause");
		pauseButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pause = true;
			}
		});

		JButton stopButton = new JButton("Stop");
		stopButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pause = true;
				frameIndex = 0;
			}
		});

		frameLabel = new JLabel("Frame "+frameIndex);
		
		buttonPanel.add(frameLabel,BorderLayout.PAGE_START);
		buttonPanel.add(playButton);
		buttonPanel.add(pauseButton);
		buttonPanel.add(stopButton);

		contentPanel.add(imagePanel);
		contentPanel.add(buttonPanel,BorderLayout.SOUTH);

		frame.getContentPane().add(contentPanel);
		frame.pack();

		frame.setVisible(true);
	}

	@Override
	public void run() {
		while(true){
			try {
				contentPanel.remove(imagePanel);

				imagePanel = imagePanelCreator(frameIndex);
				frameLabel.setText("Frame " + frameIndex);
				
				contentPanel.add(imagePanel);

				contentPanel.validate();

				if (! pause){	
					frameIndex = (frameIndex+1) % framesNumber;
					Thread.sleep(frameTime);
				}

			} catch (IOException | InterruptedException e) {
				e.printStackTrace();
			}
		}
	}

	public JPanel imagePanelCreator(int frame_i) throws IOException{

		dmd = dicomReader.getDicomMetadata();
		BufferedImage bi_stored = dicomReader.read(frame_i);
		BufferedImage bi = dmd.applyGrayscaleTransformations(bi_stored, 0);

		Rectangle bounds = new Rectangle(0,0,bi.getWidth(),bi.getHeight());

		JPanel imageP =  new JPanel(){

			private static final long serialVersionUID = 1L;

			public void paintComponent(Graphics g) {
				Rectangle r = g.getClipBounds();
				((Graphics2D)g).fill(r);
				if (bounds.intersects(r))
					try {
						g.drawImage(bi, 0, 0, null);
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
		};
		imageP.setPreferredSize(new Dimension(bi.getWidth(), bi.getHeight()));
		
		return imageP;
	}


}
