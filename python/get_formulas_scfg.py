import random
import os
import sys

def load_color_list(fn):

    color_list = []
    with open(fn) as fobj:
        for line in fobj.readlines():
           line = line.strip('\r\n ')
           (r, g, b) = map(lambda x:"%.3f"%(float(x)/255), line.split(' '))
           rgb = ','.join((r, g, b))
           color_list.append(rgb)

    return color_list

def load_h_channel_list(fn):

    h_channel_list = []
    with open(fn) as fobj:
        for line in fobj.readlines():
           line = line.strip('\r\n ')
           h_channel_list.append(line)

    return h_channel_list

def load_symbol_str_to_id(fn):

    symbol_str_to_id = {}
    with open(fn) as fobj:
        for line in fobj.readlines():
           line = line.strip('\r\n ')
           symbol_str, symbol_id = line.split(' ')
           symbol_str_to_id[symbol_str] = symbol_id

    return symbol_str_to_id


def load_grammar(fn, color_list):

    T = ['EMPTY']
    N = ['S']
    P = {}

    global g_max_recur_level
    global g_max_element_num
        
    fobj = open(fn)
    for line in fobj.readlines():
        line = line.strip('\r\n')

        if line.startswith('%'): # parameters
            
            # line[1:] skip heading % 
            key, value = line[1:].replace(' ', '').split('=')
            if (key == 'MAX_RECUR_LEVEL'):
                g_max_recur_level = int(value)
            elif (key == 'MAX_ELEMENT_NUM'):
                g_max_element_num  = int(value) 
        


        if line.find('==') >= 0:
            # print '[N]' + line
            key, val_str = line.split('==')
            key = key.replace(' ', '')
            values = map(lambda x:x.replace(' ', ''), val_str.split(','));
            T.extend(values)
            N.append(key)
            P[key] = map(lambda x:[x], values)

        if line.find('=>') >= 0:
            # print '[T]' + line
            key, val_str = line.split('=>')
            key = key.replace(' ', '')
            values = map(lambda x:x.replace(' ', ''), val_str.split(','));
            N.extend(values)
            N.append(key)
            if key in P:
                P[key].append(values)
            else:
                P[key] = [values]
    fobj.close()



    T = set(T)
    N = set(N)

    #print '[TERMS]:'
    #for t in T:
    #    print t
    #print ''

    #print '[NON-TERMS]:'
    #for n in N:
    #    print n
    #print ''

    #print '[P]:'
    #for item in P.items():
    #    print item
    #print ''

    return (T, N, P)


def colorize(words, color_list):
    
    global g_color_map
    colored_words = [];
    for w_in in words:

        color = ""
        if w_in.startswith('#C'):
            w_out = r'{\color[rgb]{#color}' + w_in.replace('#C', '')
            color = color_list[g_color_map[w_in]]
        elif w_in.endswith('C#'):
            w_out = w_in.replace('C#', '') + r'}'
        elif w_in.startswith('#NC'): # no color
            w_out = w_in.replace('#NC','')
        else:
            w_out = r'{\color[rgb]{#color}' + w_in + r'}'
            color = color_list[g_color_map[w_in]]

        #print w_out
        w_out = w_out.replace('#color', color)
        colored_words.append(w_out)
    
    return colored_words

g_color_map = {}
g_color_id  = 0
g_recursive_level = 0
g_max_recur_level = 8
g_max_element_num  = 10 

def gen_sentence(T, N, P):

    global g_color_map
    global g_color_id
    global g_recursive_level
    global g_max_element_num

    start = ['S']
   
    words = None
    while words == None or len(words) > g_max_element_num:
        g_color_map = {}
        g_color_id  = 0
        g_recursive_level = 0
        words = gen_sentence_recursive(T, N, P, start)
       

    words = filter(lambda x:x!='EMPTY', words)
    sentence = ''.join(words)
    
    return (words, sentence, g_color_map)

def gen_colored_sentence(T, N, P, color_list):


    (words, sentence, color_map) = gen_sentence(T, N, P)
    #print sentence

    colored_words = colorize(words, color_list)
    colored_sentence = ''.join(colored_words);
    
    #colored_sentence = sentence

    return (colored_words, colored_sentence, color_map)



def gen_sentence_recursive(T, N, P, orig_words):

    global g_color_id
    global g_color_map
    global g_recursive_level
    global g_max_recur_level

    if g_recursive_level >= g_max_recur_level:
        return None

    g_recursive_level = g_recursive_level + 1

    new_words = []
    flag_stop = True 
    for e in orig_words:

        if e in T:
            sub_words = [e]
            if (not (e.endswith('C#') or e.startswith('#NC'))) and (not e in g_color_map):
                g_color_id = g_color_id + 1
                g_color_map[e] = g_color_id

        elif e in N:
            flag_stop = False
            sz = len(P[e]);
            pid = random.randint(0, sz - 1)
            #print (e, "=>", P[e][pid]) 
            sub_words = P[e][pid];
           
        new_words.extend(sub_words)
   
        

    #print '\nNEW_WORDS'
    #print (new_words)
    #print ''

    if g_recursive_level >= g_max_recur_level:
        return None
    else:
        if flag_stop:
            return new_words
        else:
            return gen_sentence_recursive(T, N, P, new_words)

def post_process(latex_str):
    latex_str = latex_str.replace('%20', ' ')
    latex_str = latex_str.replace('%2C', ',')

    return latex_str    

if __name__ == '__main__':

    if (len(sys.argv) != 3):
        print "Usage: %s fn_grammar num_formula"
        sys.exit(0)

    fn_grammar  = sys.argv[1]
    num_formula = int(sys.argv[2])

    fn_symbol2id = fn_grammar.replace('grammar', 'symbol2id')
    

    color_list        = load_color_list('C:/Users/pal/Desktop/mathocr-simudata-generator/python/color-list.txt')
    h_channel_list    = load_h_channel_list('C:/Users/pal/Desktop/mathocr-simudata-generator/python/h-channel-list.txt')

    symbol_str_to_id = None
    if os.path.exists(fn_symbol2id):
        symbol_str_to_id  = load_symbol_str_to_id(fn_symbol2id)
        if not os.path.exists('C:/Users/pal/Desktop/mathocr-simudata-generator/python/tex_config/'):
            os.makedirs('C:/Users/pal/Desktop/mathocr-simudata-generator/python/tex_config')

    (T, N, P) = load_grammar(fn_grammar, color_list)
    
 
    for i in range(0, num_formula):
	
        ws, latex_str, color_map =  gen_colored_sentence(T, N, P, color_list)
        latex_str = post_process(latex_str)
        latex_str = latex_str.replace("\\", "\\\\")
        print latex_str
      
        if symbol_str_to_id is not None:
            fn_tex_config = 'C:/Users/pal/Desktop/mathocr-simudata-generator/python/tex_config/tex_%d.config'%(i+1)
            fn_color_tex = 'C:/Users/pal/Desktop/mathocr-simudata-generator/python/color_tex.tex'
            fn_color = open(fn_color_tex, 'a+')
            fn_color.write('%s\n'%(latex_str))
            with open(fn_tex_config, 'w') as fobj:
                    
                items = sorted(color_map.items(), key=lambda x:x[1])
                for symbol_str, cid in items:
                    fobj.write('%s %s\n'%(symbol_str_to_id[symbol_str], h_channel_list[cid]))

            

