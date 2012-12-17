% normalise(img, gui_handle)
% img = 3D RGB matrix
% gui_handle = the handles of the GUI.
% Returns: A normalised DIPImage version of the input matrix.

function norm = normalise(img, gui_handle)
    j = img;

    a = dip_image(j(:,:,1));
    b = dip_image(j(:,:,2));
    c = dip_image(j(:,:,3));

    %in = dip_image(j);
    
    %=== last normalize, with 2 background images===
    % if back ~= 'a'
    %     in = dip_image(in);
    %     backN = backN .* 255;
    %     
    %     %sum(sum(sum(in)))/(size(backN, 1) * size(backN, 2) * 3);
    %     
    %     nor = ~(abs(backN - in) > 20);
    %     j = back .* nor;
    %     l = in .* nor;
    %     totp = sum(sum(sum(nor)));
    %     gemj = sum(sum(sum(j))) / totp;
    %     geml = sum(sum(sum(l))) / totp;
    %     gemp = (gemj.*255)/geml;
    %     
    %     %j = double((in + gemp)./255);
    %     j = double((in.*gemp)./255);
    % else
    %     j = j ./ 255;
    %     totp = size(j, 1) * size(j, 2) * 3;
    %     gemp = sum(sum(sum(j))) / totp;
    %     
    %     in = dip_image(in);
    %     tot = (125/255) / gemp;
    %     j = double((in.*tot)./255);
    % end
    %
    %j(j > 1) = 1;
    %j(j < 0) = 0;

    %=== Normalisation based on avarage of all pixel values, bringen them back
    %to the chosen middle value of 125.
    % a = dip_image(j(:,:,1));
    % b = dip_image(j(:,:,2));
    % c = dip_image(j(:,:,3));

    % tot = 125 / (sum(sum(sum(in))) / (size(j, 1) * size(j, 2) * 3));
    % 
    % a = dip_image((a.*tot));
    % b = dip_image((b.*tot));
    % c = dip_image((c.*tot));

    %a = (a.*tot);
    %b = (b.*tot);
    %c = (c.*tot);

    %a = a/255;
    %b = b/255;
    %c = c/255;
    %     
    % a(a > 1) = 1;
    % b(b > 1) = 1;
    % c(c > 1) = 1;
    % 
    % dm = zeros(size(j, 1), size(j, 2), 3);
    % dm(:,:,1) = a;
    % dm(:,:,2) = b;
    % dm(:,:,3) = c;


    %=== Returning the normalized view
    %norm = dm;
    norm = joinchannels('rgb', a, b, c);