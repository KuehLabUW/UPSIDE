%this functions maps min and max pixel values to a new min and max pixel
%values. Any pixels outside the boundary will be suppressed to the new min max
function new_image  = linmap(image,low_in,high_in,low_out,high_out)

    a = (high_out - low_out)/(high_in - low_in);
    
    b = high_out - a*high_in;
    
    new_image = image.*a + b;
    
    new_image(new_image < low_out) = low_out;
    new_image(new_image > high_out) = high_out;

end