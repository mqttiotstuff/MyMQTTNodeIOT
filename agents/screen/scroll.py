
import font
import time

#
# construct a char representation
# 
def charSequence(char,color):
    e = font.printChar(char)
    return toLED(e,color)

def toLED(buffer, color):
    s = ""
    for i in range(7,-1,-1):
        for j in range(0,8):
            b = (buffer[j][i:i+1]) == "X"
            s = (s + color) if b else (s + chr(0)+chr(0) + chr(0))

    return s

def shiftBufferLeft(buffertoshift,enteringelements,outelements):
    assert type(buffertoshift) == list
    assert type(enteringelements) == list    
    assert len(buffertoshift) == 8
    assert len(enteringelements) == 8
    assert type(outelements) == list

    for i in range(0,8):
        s = buffertoshift[i]
        c = s[0:1]
	r = s[1:8]
        buffertoshift[i] = r + enteringelements[i] 
        outelements[i] = c

def newBuffer():
    buffer = []
    for i in range(0,8):
        buffer.append("        ")
    return buffer

def scroll(client, message, topic):
    print("message to scroll :" + str(message))
    buffer = []
    for i in range(0,8):
        buffer.append("        ")

    displayed = [buffer]
    for m in message:
        displayed.append(font.printChar(ord(m)))    

    # print(displayed)


    for i in range(0,8*(len(message) + 1)):
        a=[" "," "," "," "," "," "," "," "]
        for j in range(len(message),-1,-1):
            b=[" "," "," "," "," "," "," "," "]
            shiftBufferLeft(displayed[j],a,b)
            a=b
        #print(" display " + str(i))
        #print(displayed)
        m = toLED(displayed[0], chr(30) + chr(0) + chr(0)) 
        client.publish(topic,m)
	
        time.sleep(0.05)


