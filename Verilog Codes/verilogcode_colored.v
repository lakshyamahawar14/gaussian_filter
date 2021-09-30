module coloured#(parameter IN_FILE = "<Input_Image_Hex_File>", OUT_FILE = "<Output_Image_Hex_File_NxN>", size = 110592, rows = 192, cols = 192, Ksize = 5)();

    	real result_r[rows-1:0][cols-1:0],result_g[rows-1:0][cols-1:0],result_b[rows-1:0][cols-1:0],SigmaMatrix[Ksize-1:0][Ksize-1:0],CVector[Ksize-1:0],RVector[Ksize-1:0],sum_g_r,sum_g_g,sum_g_b,sum_s = 0,value = 1,temp = 1;
    	
		reg[7:0] memory[3*size-1:0];                          //Storing Input Image Hex data in a 'reg' type vector
		
		integer image_Red[rows-1:0][cols-1:0],image_Green[rows-1:0][cols-1:0],image_Blue[rows-1:0][cols-1:0], dx = Ksize/2,dy = Ksize/2,c = Ksize/2,i,j,k = 0,l,y,z,f;
	
	initial 
		begin
			f = $fopen(OUT_FILE,"w");                          //Opening Output Image Hex File
	
			$readmemh(IN_FILE,memory);                         //Reading Input Image Hex File and storing its data into memory

			for(i = 0; i<rows; i=i+1)

			begin

				for(j = 0; j<cols; j=j+1)  
				                     //Each color pixel has 3 RGB value pairs (Red, Green, Blue)
				begin
					image_Red[i][j] = memory[k];              //Forming a 2x2 Matrix and storing pixel values of Red Color
					k = k+1;
					
					image_Green[i][j] = memory[k];            //Forming a 2x2 Matrix and storing pixel values of Green Color
					k = k+1;

					image_Blue[i][j] = memory[k];             //Forming a 2x2 Matrix and storing pixel values of Blue Color
					k = k+1;
				end

			end

//Formation of Sigma Matrix or Kernal matrix of order Ksize

			for(i=0; i<Ksize; i=i+1)

			begin
    				CVector[i] = factorial(Ksize-1)/(factorial(Ksize-1-i)*factorial(i));

        			RVector[i] = factorial(Ksize-1)/(factorial(Ksize-1-i)*factorial(i));

    			end
			
    			for(i=0; i<Ksize; i=i+1)

			begin
       				for(j=0; j<Ksize; j=j+1)

				begin
            				SigmaMatrix[i][j] = CVector[i]*RVector[j];

            			end

			end

   			for(i = 0; i<Ksize; i=i+1)
    			begin
    				for(j = 0; j<Ksize; j=j+1)
    				begin
    					sum_s = sum_s + SigmaMatrix[i][j];
				end
			end	

			for(i = 0; i<Ksize; i=i+1)
    			begin
    				for(j = 0; j<Ksize; j=j+1)
    				begin
    					SigmaMatrix[i][j] = SigmaMatrix[i][j]/sum_s;
				end
			end

//Convolution Process
		
			for (i = 0; i < rows; i=i+1)
    			begin
        			for (j = 0; j < cols; j=j+1)
        			begin
							sum_g_r = 0; sum_g_g = 0; sum_g_b = 0; 
							
            				for (k = dx; k >= ((-1) * dx); k=k-1)
            				begin
                				for (l = dy; l >= ((-1) * dy); l=l-1)
                				begin
                    					y = i + k;
                    					z = j + l;

                    					if ((i + k) >= 0 && (i + k) < rows && (j + l) >= 0 && (j + l) < cols)
                    					begin
											sum_g_r = sum_g_r + (image_Red[y][z] * SigmaMatrix[(c + k)][(c + l)]);
                    						
											sum_g_g = sum_g_g + (image_Green[y][z] * SigmaMatrix[(c + k)][(c + l)]);

											sum_g_b = sum_g_b + (image_Blue[y][z] * SigmaMatrix[(c + k)][(c + l)]);
											
                    					end
                				end
            				end

							result_r[i][j] = sum_g_r;						//Storing new pixel values in new matrix for Red Color
							result_g[i][j] = sum_g_g;					    //Storing new pixel values in new matrix for Red Color
            				result_b[i][j] = sum_g_b;                       //Storing new pixel values in new matrix for Red Color
							                   
							                   
							
							$fdisplay(f,"%2h",result_r[i][j]); 				//Writing Red pixel values to Output Image Hex File
							          
							$fdisplay(f,"%2h",result_g[i][j]); 			    //Writing Green pixel values to Output Image Hex File
							
							$fdisplay(f,"%2h",result_b[i][j]);              //Writing Blue pixel values to Output Image Hex File
							         
        			end
			end

				
			$fclose(f);											        	//Closing Output Image Hex File
		end

//Function for calculating Factorial	
	
	function real factorial;

		input real num;
   		begin
   			if(num==0)
       				factorial = 1;
			else
			begin
    				value=1;temp = 1;
    					
    				for(temp=1;temp<=num;temp= temp+1)
				begin	
   				     value = value*temp;
    				end
    
				factorial = value;
			end
		end
	endfunction
endmodule

//Testbench

module testbench_color;
	
	parameter size = 110592, rows = 192, cols = 192;

	coloured #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_3x3>"),.size(size),.rows(rows),.cols(cols),.Ksize(3)) k3(); //Instantiating module coloured which will give Output Image Hex File for kernel size 3x3
	coloured #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_5x5>"),.size(size),.rows(rows),.cols(cols),.Ksize(5)) k5(); //Instantiating module coloured which will give Output Image Hex File for kernel size 5x5
	coloured #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_7x7>"),.size(size),.rows(rows),.cols(cols),.Ksize(7)) k7(); //Instantiating module coloured which will give Output Image Hex File for kernel size 7x7
endmodule

// This testbench is for coloured images. In this test bench, we have to assign the rows = height of the input image, cols = width of the input image and size = height*width*3 (as this is a coloured image, so we have to multipy by 3 due to its rgb values)
