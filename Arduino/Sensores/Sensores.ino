#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <EtherCard.h>

#define PINODHT 2 
#define TIPODHT DHT22

#define PORT 8080
#define STATIC 0                                //Para definir um IP estático mudar de 0 para 1
                                                //To set a static IP change from 0 to 1
                                                
#if STATIC        
  static byte myip[] = { 192,168,0,2 };   //Definição do IP estático/Setting the static IP
  static byte gwip[] = { 192,168,0,1 };     //Endereço IP do Gateway da rede/Gateway IP address of the network 
#endif
  static byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 }; //*MAC Address 
                                                           //*MAC Address da interface ethernet - Tem de ser único na sua rede 
                                                           //*MAC Address of the Ethernet interface - must be unique in your network



DHT dht(PINODHT, TIPODHT);                                                             
byte Ethernet::buffer[500];
BufferFiller bfill;
float max_h=0, max_t=0, min_h=999, min_t=999;
int uptime[5] = {0,0,0,0,0};


word hp(float temp, float humidity, float maxima_t, float minima_t, float maxima_h, float minima_h) {
    bfill = ether.tcpOffset();
    char tempe[4];
    char umid[4];
    char max_t[4];
    char min_t[4];
    char max_u[4];
    char min_u[4];
    bfill.emit_p(PSTR(
       "HTTP/1.0 200 OK\r\n"
       "Content-Type: text/html\r\n"
       "Pragma: no-cache\r\n"
       "\r\n"
       //"<meta http-equiv='refresh' content='6'/>"
       "<title>Temperature</title>" 
       "Temperatura: <br/>") 
    );
     bfill.emit_p(PSTR("Atual: $S C<br/>Maxima: $S C<br/>"), dtostrf(temp,4,1,tempe),dtostrf(maxima_t,4,1,max_t));
     bfill.emit_p(PSTR("Minima: $S C<br/><br/>"), dtostrf(minima_t,4,1,min_t));
     bfill.emit_p(PSTR("Umidade: <br/>"));
     bfill.emit_p(PSTR("Atual: $S %<br/>Maxima: $S %<br/>Minima: $S %<br/>"),dtostrf(humidity,4,1,umid),dtostrf(maxima_h,4,1,max_u),dtostrf(minima_h,4,1,min_u));
     bfill.emit_p(PSTR("Uptime: $D dias, $D horas, $D minutos, $D segundos, $D milisegundos<br/>"), uptime[0], uptime[1], uptime[2], uptime[3], uptime[4]);
     
    return bfill.position();
}

void setup(){
   Serial.begin(57600);
   Serial.println( "Modulo Ethernet ENC28J60/ENC28J60 Ethernet module");
   Serial.println("\n[webserver]");

   if (ether.begin(sizeof Ethernet::buffer, mymac) == 0)
      Serial.println( "Falha ao aceder ao controlador Ethernet/Failed to access Ethernet controller");

      #if STATIC
          ether.staticSetup(myip, gwip);
      #else
          if (!ether.dhcpSetup())
              Serial.println("DHCP falhou / DHCP failed");
      #endif

   Serial.println("Parametros da rede / Network parameters");
   ether.printIp("IP: ", ether.myip);
   ether.printIp("GW: ", ether.gwip);
   ether.printIp("DNS: ", ether.dnsip);
   ether.hisport = PORT;
}


void loop(){
  float h = dht.readHumidity(); // Lê a umidade
  float t = dht.readTemperature(); // Lê a temperatura

  if(uptime[4] == 1000) {
    uptime[3] += 1;
    uptime[4] = 0;
  }

  if(uptime[3] == 60) { // Verifica se contou 1 minuto
    uptime[2] += 1;
    uptime[3] = 0;
  }

  if(uptime[2] == 60) { // Verifica se contou uma hora
    uptime[1] += 1;
    uptime[2] = 0;
  }

  if(uptime[1] == 24) { // Verifica se contou 1 dia
    uptime[0] += 1;
    uptime[1] = 0;
  }
  
  if(h >= max_h){ // Acha a umidade máxima
    max_h = h;
  }

  if(h < min_h){ // Acha a umidade minima
    min_h = h;
  }

  if(t >= max_t) { // Acha a temperatura máxima
    max_t = t;
  }

  if(t < min_t) { // Acha a temperatura minima
    min_t = t;
  }
  
   if (ether.packetLoop(ether.packetReceive())) { // Espera um request
      ether.httpServerReply(hp(t,h,max_t,min_t,max_h,min_h));
   }

   uptime[4] += 1; // Soma um nos segundos
   //Serial.println(uptime[4]);
   delay(1); // Aguarda 1 segundo
}
