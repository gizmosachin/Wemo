# Wemo.sh

- WeMo accepts `POST` requests
  
- Define `ACTION` to be one of the following:
  
  - Set state = `SetBinaryState`
  - Get state = `GetBinaryState`
  - Get signal strength = `GetSignalStrength`
  - Get friendly name = `GetFriendlyName`
  
- Headers
  
  - `Accept: `
  - `Content-type: text/xml; charset="utf-8"`
  - `SOAPACTION: \"urn:Belkin:service:basicevent:1#ACTION`
  
- Data
  
  - Set state, replace `BinaryState` with 0 or 1
    
    ``` xml
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:ACTION xmlns:u="urn:Belkin:service:basicevent:1">
          <BinaryState>0</BinaryState>
        </u:ACTION>
      </s:Body>
    </s:Envelope>
    ```
    
  - Get signal strength
    
    ``` xml
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:GetSignalStrength xmlns:u="urn:Belkin:service:basicevent:1">
        	<GetSignalStrength>0</GetSignalStrength>
        </u:GetSignalStrength>
      </s:Body>
    </s:Envelope>
    ```
    
  - Get friendly name
    
    ``` xml
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:GetFriendlyName xmlns:u="urn:Belkin:service:basicevent:1">
          <FriendlyName></FriendlyName>
        </u:GetFriendlyName>
      </s:Body>
    </s:Envelope>
    ```
    
  - Get state
    
    ``` xml
    <?xml version="1.0" encoding="utf-8"?>
    <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
      <s:Body>
        <u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1">
          <BinaryState>1</BinaryState>
        </u:GetBinaryState>
      </s:Body>
    </s:Envelope>
    ```
    
    ​
  
- URL: 
  
  - $IP is the IP address of the device
  - $PORT is the port of the device
  - `http://$IP:$PORT/upnp/control/basicevent1`
  
- Decoding
  
  - MAC Address must be in the range `EC:1A:59:00:00:00`  - `EC:1A:59:FF:FF:FF` to be from Belkin