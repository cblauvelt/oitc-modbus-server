# Quick reference

Fork of modbus-server from Oberdorf IT-Consulting. Includes additional init scripts for docker-compose.

Maintained by: [Michael Oberdorf IT-Consulting](https://www.oberdorf-itc.de/)

Source code: [Bitbucket](https://bitbucket.org/Cybcon/modbus-server/src/master/)

# Supported tags and respective `Dockerfile` links

- [`latest`, `1.1.2`](https://bitbucket.org/Cybcon/modbus-server/src/1.1.2/Dockerfile)

# What is Modbus TCP Server?

The Modbus TCP Server is a simple, in python written, Modbus TCP server. It listens to port 502 and respond to any register types with a `0x0000`.
The Modbus registers can be also predefined with values.

# QuickStart with Modbus TCP Server and Docker

Step - 1 : Pull the Modbus TCP Server

```bash
docker pull cblauvelt/modbus-server
```

Step - 2 : Run the Modbus TCP Server

```bash
docker run --rm -p 502:502 cblauvelt/modbus-server:latest
```

Alternatively, you can run this using docker-compose

```bash
docker-compose -f examples/docker-init/docker-compose.yaml up
```

Step - 3 : Predefine registers

The default configuration file is configured to initialize every register with a `0x0000`.
To set register values, you need to create your own configuration file.

An example can be found in the GIT repo: [abb_coretec_example.json](https://github.com/cblauvelt/oitc-modbus-server/blob/main/examples/abb_coretec_example.json)

```bash
docker run --rm -p 502:502 -v ./server_config.json:/server_config.json oitc/modbus-server:latest -f /server_config.json
```

# Configuration

## Default configuration

```json
{
  "server": {
    "listenerAddress": "0.0.0.0",
    "listenerPort": 502,
    "tlsParams": {
      "description": "path to certificate and private key to enable tls",
      "privateKey": null,
      "certificate": null
    },
    "logging": {
      "format": "%(asctime)-15s %(threadName)-15s  %(levelname)-8s %(module)-15s:%(lineno)-8s %(message)s",
      "logLevel": "DEBUG"
    }
  },
  "registers": {
    "description": "initial values for the register types",
    "zeroMode": false,
    "initializeUndefinedRegisters": true,
    "discreteInput": {},
    "coils": {},
    "holdingRegister": {},
    "inputRegister": {}
  }
}
```

## Predefined registers

```json
{
  "server": {
    "listenerAddress": "0.0.0.0",
    "listenerPort": 502,
    "tlsParams": {
      "description": "path to certificate and private key to enable tls",
      "privateKey": null,
      "certificate": null
    },
    "logging": {
      "format": "%(asctime)-15s %(threadName)-15s  %(levelname)-8s %(module)-15s:%(lineno)-8s %(message)s",
      "logLevel": "DEBUG"
    }
  },
  "registers": {
    "description": "initial values for the register types",
    "zeroMode": false,
    "initializeUndefinedRegisters": true,
    "discreteInput": {},
    "coils": {},
    "holdingRegister": {
      "123": "0xAABB",
      "246": "0x0101"
    },
    "inputRegister": {}
  }
}
```

# Docker compose

```yaml
version: "3"
services:
  modbus-server:
    container_name: modbus-server
    image: cblauvelt/modbus-server
    restart: always
    command: -f /server_config.json
    ports:
      - 502:502
    volumes:
      - ./server_config.json:/server_config.json:ro
```

# License

Copyright (c) 2020 Michael Oberdorf IT-Consulting

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
