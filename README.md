
<h1 align="center">

  Ubuntu-VPS-init
</h1>

<h4 align="center">A bash script to init common features on a fresh Ubuntu VPS.</h4>


<p align="center">
  <a href="#key-features">Key Features</a> •
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a>
</p>


## Key Features

* Non-root user creation (optional root privileges)
* Docker & Docker-compose installation
* UFW firewall config (Default SSH, HTTP, HTTPS)
* SSH config (No root login, no password login, etc.)
* SSH key copy from Root -> New user
* Optional external data directory check function.

## How To Use

To clone and run this application, from your command line:

```bash
# Clone this repository
$ git clone https://github.com/twwhite/ubuntu-vps-init

# Change directory into the repository
$ cd ubuntu-vps-init

# Run the appropriate init script(s)
$ ./01-all-debian-init.sh
```
Note: You may need to modify file permissions to permit execute by running chmod +x.


## License

MIT License - Copyright (c) 2021 Tim White

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

> [timwhite.io](https://timwhite.io) &nbsp;&middot;&nbsp;
> GitHub [@twwhite](https://github.com/twwhite) &nbsp;&middot;&nbsp;
> Twitter [@timwhiteio](https://twitter.com/timwhiteio)

