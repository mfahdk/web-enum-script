# HTB Web Enumeration Script

A simple Bash script for automating some initial web enumeration on Hack The Box machines.

The script:

* Takes a target IP as an argument.
* Uses Nmap to identify the target hostname.
* Adds the hostname/IP mapping to `/etc/hosts`.
* Determines baseline response sizes for directory and subdomain enumeration.
* Runs `ffuf` for directory enumeration and virtual-host/subdomain enumeration in parallel.
* Saves the results to `dir.txt` and `subdomain.txt`.

### Usage

```bash
./enum.sh <IP>
```

Example:

```bash
./enum.sh 10.10.10.10
```

### PS

This is **not the most efficient, robust, or polished enumeration script**. It's a personal automation script I put together for my HTB workflow to save some repetitive steps during initial enumeration. It makes several assumptions about the target's HTTP/Nmap output, `/etc/hosts` format, installed tools, and wordlist locations, so it may need adjustments depending on the machine/environment.
