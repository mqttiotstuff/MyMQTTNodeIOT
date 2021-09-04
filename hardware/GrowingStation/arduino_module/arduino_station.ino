/**
 * this sketch communicate on serial interface to query sensors
 * 
 * Protocol is the SXXXYYYYYYYYYY\n
 * XXX is the formatted length of the payload
 * YYYYY is the payload
 * \n end the message
 * 
 * COMMANDS : 
 * LIST -> get the list of sensors, with the following capabilities
 * Q: Query
 * W: Write
 * P: Pulse
 * 
 */



#include <DHT.h>
#define DHTPIN 2
#define DHTTYPE DHT22 

#include "SerialCommandParser.h"

// define global sensors
DHT dht(DHTPIN, DHTTYPE);


#define LIGHT_SENSOR_PIN A1
#define MOISTURE_SENSOR_PIN A0

#define LIGHT_COMMAND_PIN 3
#define PUMP_COMMAND_PIN 5


static parser_t parser;
static char bufferMessage[200];
static char ftoa[20];




void setup() {
  Serial.begin(115200);
  dht.begin();
  init(&parser);

  pinMode(LIGHT_COMMAND_PIN, OUTPUT);
  
  pinMode(LIGHT_SENSOR_PIN, INPUT);
  pinMode(MOISTURE_SENSOR_PIN, INPUT);
}

void commandCanceled() {
  Serial.println("commandCanceled");
}

int readUpStream() {
  return Serial.read();
}

void pushMessage(char* message) {
  int message_length = strlen(message);
  // copy message
  sprintf(bufferMessage, "S%03d%s\n", message_length, message);
  Serial.print(bufferMessage);  
}


void pushMessageWithValue(char* message, float f) {
  char msgbuffer[100];
  char floatString[10];
  dtostrf(f,4,2,floatString); // sprintf does not support %f
  sprintf(msgbuffer, "%s:%s", message, floatString);
  pushMessage(msgbuffer);
}


void command(const char *command) {

  if (startsWith(command, "LIST")) {
    // list all sensors
    pushMessage("TEMPERATURE(Q)|HUMIDITY(Q)|LIGHT(QW)|SOIL(Q)|FAN(P)|PUMP(WP)");
  } else if (startsWith(command, "QUERY-TEMPERATURE")) {
     float t = (float) dht.readTemperature();
     pushMessageWithValue("TEMPERATURE",t);  
  }else if (startsWith(command, "QUERY-HUMIDITY")) {
    pushMessageWithValue("HUMIDITY",(float) dht.readHumidity());   
  }else if (startsWith(command, "QUERY-LIGHT")) {
    pushMessageWithValue("LIGHT", analogRead(LIGHT_SENSOR_PIN));   
  }else if (startsWith(command, "QUERY-SOIL")) {
    pushMessageWithValue("SOIL:",analogRead(MOISTURE_SENSOR_PIN));      
  }else if (startsWith(command, "PULSE-PUMP")) {
    int value = atoi(command + 10);
    analogWrite(PUMP_COMMAND_PIN,value);
    delay(3000);
    analogWrite(PUMP_COMMAND_PIN,0);
    pushMessage("OK");
  }else if (startsWith(command, "SET-LIGHT")) {
    int value = atoi(command + 9);
    analogWrite(LIGHT_COMMAND_PIN,value);
    pushMessage("OK");
  }else if (startsWith(command, "SET-PUMP")) {
    int value = atoi(command + 8);
    analogWrite(PUMP_COMMAND_PIN,value);
    pushMessage("OK");
  }else {
    pushMessage("ERR:Unknown command ");
  }
}


void loop() {
    handleSerialReceive(&parser, &command, &readUpStream, &commandCanceled);
}
