module greyscale#(parameter IN_FILE = "<Input_Image_Hex_File>", OUT_FILE = "<Output_Image_Hex_File_NxN>", size = 36960, rows = 168, cols = 220, Ksize = 5)();

    	real result[rows-1:0][cols-1:0],SigmaMatrix[Ksize-1:0][Ksize-1:0],CVector[Ksize-1:0],RVector[Ksize-1:0],sum_g,sum_s = 0,value = 1,temp = 1;
    	
		reg[7:0] memory[size-1:0];                        	     //Storing Input Image Hex data in a 'reg' type vector
		
		integer Input_image[rows-1:0][cols-1:0], dx = Ksize/2,dy = Ksize/2,c = Ksize/2,i,j,k = 0,l,y,z,f;
	
	initial 
		begin
			f = $fopen(OUT_FILE,"w");                            //Opening Output Image Hex File
	
			$readmemh(IN_FILE,memory);                           //Reading Input Image Hex File and storing its data into memory

			for(i = 0; i<rows; i=i+1)
			begin
				for(j = 0; j<cols; j=j+1)                       
				begin
					Input_image[i][j] = memory[k];               //Forming a 2x2 Matrix and storing pixel values of Blue Color
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
							sum_g = 0;
							
            				for (k = dx; k >= ((-1) * dx); k=k-1)
            				begin
                				for (l = dy; l >= ((-1) * dy); l=l-1)
                				begin
                    					y = i + k;
                    					z = j + l;

                    					if ((i + k) >= 0 && (i + k) < rows && (j + l) >= 0 && (j + l) < cols)
                    					begin
                    						sum_g = sum_g + (Input_image[y][z] * SigmaMatrix[(c + k)][(c + l)]);
                    					end
                				end
            				end

            				result[i][j] = sum_g;                       //Storing new pixel values in new matrix 
							
							$fdisplay(f,"%2h",result[i][j]);            //Writing new pixel values to Output Image Hex File
        			end
			end
			
			$fclose(f);                                                 //Closing Output Image Hex File
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

module testbench_grey;
	
	parameter size = 36960, rows = 168, cols = 220;

	greyscale #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_3x3>"),.size(size),.rows(rows),.cols(cols),.Ksize(3)) k3();  //Instantiating module greyscale which will give Output Image Hex File for kernel size 3x3
	greyscale #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_5x5>"),.size(size),.rows(rows),.cols(cols),.Ksize(5)) k5();  //Instantiating module greyscale which will give Output Image Hex File for kernel size 5x5
	greyscale #(.IN_FILE("<Input_Image_Hex_File>"),.OUT_FILE("<Output_Image_Hex_File_5x5>"),.size(size),.rows(rows),.cols(cols),.Ksize(7)) k7();  //Instantiating module greyscale which will give Output Image Hex File for kernel size 7x7
	
endmodule

// This testbench is for coloured images. In this test bench, we have to assign the rows = height of the input image, cols = width of the input image and size = height*width*1 (as this is a greyscale image, so we don't have RGB triplet in this case)
