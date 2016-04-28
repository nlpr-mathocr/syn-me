clear; clc

if ~isdir('tex_config2/')
    mkdir('tex_config2');
end

f_num = length(dir('tex_config/*.config'));

for i = 1 : f_num
    fp_r = fopen(strcat('tex_config/tex_', num2str(i), '.config'), 'r');
    fp_w = fopen(strcat('tex_config2/tex_', num2str(i), '.config'), 'w');
    while 1
        symbol = fgetl(fp_r);
        if symbol == -1
            break;
        end
        hval = str2double(fgetl(fp_r));
        % convert symbol to label

        if strcmp(symbol, '\\times')
            symbol = 25;
        elseif strcmp(symbol, '>')
            symbol = 28;
        elseif strcmp(symbol, '<')
            symbol = 29;
        elseif strcmp(symbol, '+')
            symbol = 23;
        elseif strcmp(symbol, '-')
            symbol = 24;
        elseif strcmp(symbol, '=')
            symbol = 27;
        elseif strcmp(symbol, '\\sqrt{')
            symbol = 30;	   
        elseif strcmp(symbol, '/')
            symbol = 26;
        elseif strcmp(symbol, 'a')
            symbol = 11;
        elseif strcmp(symbol, 'b')
            symbol = 12;
        elseif strcmp(symbol, 'c')
            symbol = 13;
        elseif strcmp(symbol, 'x')
            symbol = 14;
        elseif strcmp(symbol, 'y')
            symbol = 15;
        elseif strcmp(symbol, 'z')
            symbol = 16;
        elseif strcmp(symbol, 'A')
            symbol = 17;
        elseif strcmp(symbol, 'B')
            symbol = 18;
        elseif strcmp(symbol, 'C')
            symbol = 19;
        elseif strcmp(symbol, 'X')
            symbol = 20;
        elseif strcmp(symbol, 'Y')
            symbol = 21;
        elseif strcmp(symbol, 'Z')
            symbol = 22;

        elseif strcmp(symbol, '1')
            symbol = 1;
        elseif strcmp(symbol, '2')
            symbol = 2;
        elseif strcmp(symbol, '3')
            symbol = 3;
        elseif strcmp(symbol, '4')
            symbol = 4;
        elseif strcmp(symbol, '5')
            symbol = 5;
        elseif strcmp(symbol, '6')
            symbol = 6;
        elseif strcmp(symbol, '7')
            symbol = 7;
        elseif strcmp(symbol, '8')
            symbol = 8;
        elseif strcmp(symbol, '9')
            symbol = 9;
        elseif strcmp(symbol, '0')
            symbol = 10;

        elseif strcmp(symbol, '\\frac{')
            symbol = 31;
        end
        fprintf(fp_w, '%d %f\n', symbol, hval);
        
    end
    
    
    
    fclose(fp_r);
    fclose(fp_w);
end

