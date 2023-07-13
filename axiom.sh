#clone chaos directory and extract rootdomains
axiom-exec 'cd /home/op/recon; git clone https://github.com/UnaPibaGeek/ctfr.git; cd ctfr; pip3 install -r requirements.txt'
#axiom-exec 'cd /home/op/recon; git clone https://github.com/cramppet/regulator; cd regulator; pip3 install -r requirements.txt'

#echo "clone chaos directory and extract rootdomains"
#cd /home/hacker/public-bugbounty-programs
#git pull;
#python3 chaos.py --exclude "Alibaba, Stanford University, Lazada"

#cd /home/hacker/axiom-recon
#mv /home/hacker/public-bugbounty-programs/rootdomains.txt .

bbrf scope in --all | grep "*" | grep -v "lacity.org\|abb.com\|daraz.com\|comcast.net\|telefonica.de\|telenet.be\|telenor.se\|bredbandsbolaget.se\|bandcamp.com\|tumblr.com\|taobao.com\|aliyun\|tmall.com\|1688.com\|ownit.se\|alibaba\|lazada\|aliexpress\|alimama" | cut -d "." -f 2-10 > rootdomains.txt
#Finding subdomains using subfinder, Assetfinder and findomain
echo "Finding subdomains using subfinder, Assetfinder and findomain"
axiom-scp /home/hacker/wordlist/subfinderconfig.yaml 'recon*':/home/op/.config/subfinderconfig.yaml
axiom-scp /home/hacker/wordlist/config.ini 'recon*':/home/op/.config/amass/config.ini
axiom-scp /home/hacker/wordlist/config.ini 'recon*':/home/op/.axiom/configs/config.ini

#dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o resolvers.txt

axiom-scan rootdomains.txt -m assetfinder -o assetfinder.txt
axiom-scan rootdomains.txt -m findomain -o findomain.txt
axiom-scan rootdomains.txt -m subfinder -o subfinder.txt
axiom-scan rootdomains.txt -m ctfr -o ctfr.txt
#axiom-scan rootdomains.txt -m amass -o amass.txt

chaos -key f286eddccad5d2001cf46b5485371cdd65b0e0e1da5a774cee0bba0378d741f2 -dL rootdomains.txt -o chaos.txt
#bbrf scope in --all | grep -v "*" | anew bbrf.txt
cat assetfinder.txt ctfr.txt findomain.txt subfinder.txt chaos.txt | grep -v "cust.swisscom.ch\|alibaba.com" | anew subdomain.txt
rm assetfinder.txt ctfr.txt findomain.txt subfinder.txt chaos.txt 

bbrf programs | tee -a programlist
for program in $(cat programlist); do
bbrf use $program
cat subdomain.txt | bbrf domain add -
done 

rm subdomain.txt programlist
bbrf domains --all > subdomain.txt
#axiom-scp /home/hacker/dnsvalidator/resolvers.txt 'recon*':/home/op/lists/resolvers.txt
echo "Resolving domains using puredns"
#axiom-scan subdomain.txt -m puredns-resolve -o resolveddomains
#rm subdomain.txt rootdomains.txt
axiom-scan subdomain.txt -m httpx -o httpxdomains
cat httpxdomains | anew -t oldhttpxdomains > newhttpx
#cat newhttpx | notify 
axiom-scan httpxdomains -m nuclei -o nucleiresults.txt
cat nucleiresults.txt | anew -t oldnucleiresults.txt > newvuln.txt
cat newvuln.txt | notify
mv httpxdomains oldhttpxdomains
mv nucleiresults.txt oldnucleiresults.txt
#axiom-rm '\*' -f
