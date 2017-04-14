%--------------------------------------------------------------------------
% Created: 7/5/12    by William J. Ebel  (All Rights Reserved)
%
% Revision History:   Adapted from Rob code
%
% Purpose: This function finds the necessary parameters to convert the red
%   line from pixel coordinates to physical coordinates.  The method to
%   perform the coordinate conversion and the required calibration is
%   described below. 
%
% Variables:
%   im - input image
%   zoom - vector with values ranging from [1,100] indicating the zoom
%          level for each pixel acquisition.  For example, if zoom = 100,
%          then each pixel is selected with a single mouse click and with
%          the full image displayed.  If zoom = [100 10], then each pixel
%          is selected with 2 mouse clicks with the first one with 100% of
%          the image displayed and the second one with only 10% of the
%          image displayed. 
%   M    - The pixel to (x,y) coordinate conversion matrix. 
%      
% function M = Find_xform(im,zoom)
%--------------------------------------------------------------------------
function M = Find_xform(im,zoom)

if nargin == 1; zoom = 100; end

disp(' ')
disp('----------------------------------------------------------------------')
disp('*********** PIXEL => PHYSICAL COORDINATE TRANSFORMATION **********')

%-----------
disp(' ')
disp('* Select the UPPER LEFT-hand corner point of the rectangular tiles.')
p00px = Select_im_pts(im,1,zoom);

p00ph = [];
while length(p00ph) ~= 2
  str = input('* Enter the floor coordinate vector for this point, [x y]: ','s');
  str = strrep(str,'[',' ');
  str = strrep(str,']',' ');
  str = strrep(str,',',' ');

  p00ph = sscanf(str,'%g')';
  if length(p00ph) ~= 2
    disp('*** ERROR.  You need to enter 2 number to define a coordinate point');
    disp('  ... try again');
  end
end
p00ph

%-----------
disp(' ')
disp('* Select the UPPER RIGHT-hand corner point of the rectangular tiles.')
p01px = Select_im_pts(im,1,zoom);

p01ph = [];
while length(p01ph) ~= 2
  str = input('* Enter the floor coordinate vector for this point, [x y]: ','s');
  str = strrep(str,'[',' ');
  str = strrep(str,']',' ');
  str = strrep(str,',',' ');

  p01ph = sscanf(str,'%g')';
  if length(p01ph) ~= 2
    disp('*** ERROR.  You need to enter 2 number to define a coordinate point');
    disp('  ... try again');
  end
end

%-----------
disp(' ')
disp('* Select the LOWER LEFT-hand corner point of the rectangular tiles.')
p10px = Select_im_pts(im,1,zoom);

p10ph = [];
while length(p10ph) ~= 2
  str = input('* Enter the floor coordinate vector for this point, [x y]: ','s');
  str = strrep(str,'[',' ');
  str = strrep(str,']',' ');
  str = strrep(str,',',' ');

  p10ph = sscanf(str,'%g')';
  if length(p10ph) ~= 2
    disp('*** ERROR.  You need to enter 2 number to define a coordinate point');
    disp('  ... try again');
  end
end

%-----------
disp(' ')
disp('* Select the LOWER RIGHT-hand corner point of the rectangular tiles.')
p11px = Select_im_pts(im,1,zoom);

p11ph = [];
while length(p11ph) ~= 2
  str = input('* Enter the floor coordinate vector for this point, [x y]: ','s');
  str = strrep(str,'[',' ');
  str = strrep(str,']',' ');
  str = strrep(str,',',' ');

  p11ph = sscanf(str,'%g')';
  if length(p11ph) ~= 2
    disp('*** ERROR.  You need to enter 2 number to define a coordinate point');
    disp('  ... try again');
  end
end

% Convert each point to HC form
p00px = [p00px(:)' 1];  p00ph = [p00ph(:)' 1];
p01px = [p01px(:)' 1];  p01ph = [p01ph(:)' 1];
p10px = [p10px(:)' 1];  p10ph = [p10ph(:)' 1];
p11px = [p11px(:)' 1];  p11ph = [p11ph(:)' 1];

pts = [p00ph,p01ph,p10ph,p11ph,p00px,p01px,p10px,p11px];

M = Find_M(p00ph,p01ph,p10ph,p11ph,p00px,p01px,p10px,p11px);

% Check the calculations
% disp(' ')
% disp('* Checking the coordinate transformations *')
% 
% a = p00px; b = a * M; b = b/b(3);
% out = sprintf('  measured p00ph(%6.2f %6.2f %6.2f)    calc p00ph(%6.2f %6.2f %6.2f)',p00ph,b); disp(out)
% 
% a = p01px; b = a * M; b = b/b(3);
% out = sprintf('  measured p01ph(%6.2f %6.2f %6.2f)    calc p01ph(%6.2f %6.2f %6.2f)',p01ph,b); disp(out)
% 
% a = p10px; b = a * M; b = b/b(3);
% out = sprintf('  measured p10ph(%6.2f %6.2f %6.2f)    calc p10ph(%6.2f %6.2f %6.2f)',p10ph,b); disp(out)
% 
% a = p11px; b = a * M; b = b/b(3);
% out = sprintf('  measured p11ph(%6.2f %6.2f %6.2f)    calc p11ph(%6.2f %6.2f %6.2f)',p11ph,b); disp(out)
% 
% disp(' ');
% out = sprintf('  Mpx2ph:  %8.3f  %8.3f  %8.3f',M(1,:)); disp(out)
% out = sprintf('           %8.3f  %8.3f  %8.3f',M(2,:)); disp(out)
% out = sprintf('           %8.3f  %8.3f  %8.3f',M(3,:)); disp(out)

end

%--------------------------------------------------------------------------
% 
% Created: 8/6/12    by William J. Ebel (All Rights Reserved)
%
% Revision History:  None
%
% Purpose:  This script calculates coordinate conversion matrices for
%   converting between physical coordinates and pixel coordinates.  As
%   implemented here, this method assumes that the webcam is imaging a flat
%   surface, the floor, with all z-coordinate values being set to zero.
%   That is, the floor lies at z=0 in physical (world) coordinates.  Note
%   that this transformation cannot accomodate non-planar (z=0) points in
%   physical coordinates, nor does it provide a complete camera matrix.  It
%   only results in a partial camera matrix for 3D points in the x-y plane.
%
%   If aph is a point in physical coord (homogeneous form), then the
%   cooresponding point in pixel coordinates (homogeneous form) is:
%
%       apx = aph * tl.Mph2px    (apx, aph row vectors)
%
%   where apx = (r, c, 1) and aph = (x, y, 1), with the z-component of aph
%   arbitrarily set to zero.  
%
%   Likewise, converting the other way is:  
%
%       aph = apx * tl.Mph2px     (apx, aph row vectors)
% 
%   The method used to find the transformation matrices results from using
%   4 points where the physical and pixel coordinates are known. Call these
%
%       a0 (ph) and  b0 (px)
%       a1 (ph) and  b1 (px)
%       a2 (ph) and  b2 (px)
%       a3 (ph) and  b3 (px)
%
%   We assume that the last component of each of these points is 1.  We
%   also assume that the z-component of each of the physical coordinate
%   points is 0 so that a0, ..., a3 are 3-component vectors.  Then the
%   unknown transformation matrix is given by:  
%
%              _           _     _           _
%             | m00 m01 m02 |   | m00 m01 m02 |
%             |             |   |             |
%         M = | m10 m11 m12 | = | m10 m11 m12 |
%             |             |   |             |
%             | m20 m21 m22 |   | m20 m21  1  |
%              -           -     -           -
%
%   Where m22 can be arbitrarily set to 1 due to the scale invariance of
%   the points in HC form.  
%
%   The 1st equation is constructed as follows:   
%
%              m00*a0x + m01*a0y + m02
%        b0r = -----------------------
%              m20*a0x + m21*a0y +  1       (normalizing constant)
%
%   multiplying through and rearranging gives the 1st equation
%
%        b0r = m00*a0x + m01*a0y + m02 - m20*(a0x*b0r) - m21*(a0y*b0r)
%
%   The other equations follow in a likewise manner: 
%
%        b0c = m10*a0x + m11*a0y + m12 - m20*(a0x*b0c) - m21*(a0y*b0c)
%        b1r = m00*a1x + m01*a1y + m02 - m20*(a1x*b1r) - m21*(a1y*b1r)
%        b1c = m10*a1x + m11*a1y + m12 - m20*(a1x*b1c) - m21*(a1y*b1c)
%        b2r = m00*a2x + m01*a2y + m02 - m20*(a2x*b2r) - m21*(a2y*b2r)
%        b2c = m10*a2x + m11*a2y + m12 - m20*(a2x*b2c) - m21*(a2y*b2c)
%        b3r = m00*a3x + m01*a3y + m02 - m20*(a3x*b3r) - m21*(a3y*b3r)
%        b3c = m10*a3x + m11*a3y + m12 - m20*(a3x*b3c) - m21*(a3y*b3c)
%
%   These equations can be reformulated in matrix form as:
%
%      _                                         _     _   _     _   _
%     | a0x a0y  1   0   0   0  -a0x*b0r -a0y*b0r |   | m00 |   | b0r |
%     |  0   0   0  a0x a0y  1  -a0x*b0c -a0y*b0c |   | m01 |   | b0c |
%     | a1x a1y  1   0   0   0  -a1x*b1r -a1x*b1r |   | m02 |   | b1r |
%     |  0   0   0  a1x a1y  1  -a1x*b1c -a1x*b1c |   | m10 |   | b1c |
%     | a2x a2y  1   0   0   0  -a2x*b2r -a2x*b2r | * | m11 | = | b2r |
%     |  0   0   0  a2x a2y  1  -a2x*b2c -a2x*b2c |   | m12 |   | b2c |
%     | a3x a3y  1   0   0   0  -a3x*b3r -a3x*b3r |   | m20 |   | b3r |
%     |  0   0   0  a3x a3y  1  -a3x*b3c -a3x*b3c |   | m21 |   | b3c |
%      -                                         -     -   -     -   -
%
%                            Ma                     *   MV    =   bV
%
%   from which the solution is found by,
%
%                   MV = inv(Ma)*bV
%
%   which is a matrix used to convert from physical coordinates to pixel
%   coordinates. 
%
%   Finding the inverse of MV gives a coordinate conversion from pixel
%   coordinates to physical coordinates.  
% 
%--------------------------------------------------------------------------
function Mrc2xy = Find_M(p00ph,p01ph,p10ph,p11ph,p00px,p01px,p10px,p11px)

%--------------------------------
% Find the physical coordinate to pixel coordinate transformation matrix
zz = zeros(1,3);

a0 = p00ph;  b0 = p00px;
a1 = p01ph;  b1 = p01px;
a2 = p10ph;  b2 = p10px;
a3 = p11ph;  b3 = p11px;

Ma = [a0 zz -a0(1:2)*b0(1); zz a0 -a0(1:2)*b0(2); ...
      a1 zz -a1(1:2)*b1(1); zz a1 -a1(1:2)*b1(2); ...
      a2 zz -a2(1:2)*b2(1); zz a2 -a2(1:2)*b2(2); ...
      a3 zz -a3(1:2)*b3(1); zz a3 -a3(1:2)*b3(2)];

bV = [b0(1:2) b1(1:2) b2(1:2) b3(1:2)]';

M = Ma \ bV;

Mxy2rc = [M(1) M(2) M(3); M(4) M(5) M(6); M(7) M(8) 1];
Mxy2rc = Mxy2rc';  % Transpose for right-side multiplication

% Check to see that the equations are satisfied
% M(1)*a0(1) + M(2)*a0(2) + M(3) - M(7)*a0(1)*b0(1) - M(8)*a0(2)*b0(1) - b0(1)
% M(4)*a0(1) + M(5)*a0(2) + M(6) - M(7)*a0(1)*b0(2) - M(8)*a0(2)*b0(2) - b0(2)
% 
% M(1)*a1(1) + M(2)*a1(2) + M(3) - M(7)*a1(1)*b1(1) - M(8)*a1(2)*b1(1) - b1(1)
% M(4)*a1(1) + M(5)*a1(2) + M(6) - M(7)*a1(1)*b1(2) - M(8)*a1(2)*b1(2) - b1(2)
% 
% M(1)*a2(1) + M(2)*a2(2) + M(3) - M(7)*a2(1)*b2(1) - M(8)*a2(2)*b2(1) - b2(1)
% M(4)*a2(1) + M(5)*a2(2) + M(6) - M(7)*a2(1)*b2(2) - M(8)*a2(2)*b2(2) - b2(2)
% 
% M(1)*a3(1) + M(2)*a3(2) + M(3) - M(7)*a3(1)*b3(1) - M(8)*a3(2)*b3(1) - b3(1)
% M(4)*a3(1) + M(5)*a3(2) + M(6) - M(7)*a3(1)*b3(2) - M(8)*a3(2)*b3(2) - b3(2)

% Use the inverse to construct the matrix for the pixel to physical trans.
Mrc2xy = inv(Mxy2rc);

end
