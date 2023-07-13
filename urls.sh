axiom-scan ../oldhttpxdomains -m katana -o katana.txt
cat katana.txt | grep = | grep -v -E '\.jpg|\.jpeg|\.gif|\.css|\.tif|\.tiff|\.png|\.ttf|\.woff|\.woff2|\.ico|\.pdf|\.svg|\.txt|\.js|\.json' | uro | anew kurls.txt
axiom-scan ../oldhttpxdomains -m gauplus -o gauplus.txt
cat gauplus.txt | grep = | grep -v -E '\.jpg|\.jpeg|\.gif|\.css|\.tif|\.tiff|\.png|\.ttf|\.woff|\.woff2|\.ico|\.pdf|\.svg|\.txt|\.js|\.json' | uro | anew gaurls.txt
axiom-scan ../oldhttpxdomains -m hakrawler -o hakurls.txt
cat hakurls.txt | grep = | grep -v -E '\.jpg|\.jpeg|\.gif|\.css|\.tif|\.tiff|\.png|\.ttf|\.woff|\.woff2|\.ico|\.pdf|\.svg|\.txt|\.js|\.json' | uro | anew hurls.txt
axiom-scan ../oldhttpxdomains -m gospider --blacklist jpg,jpeg,gif,css,tif,tiff,png,ttf,woff,woff2,ico,pdf,svg,txt,js,json -o gospider
for domain in $(cat ../rootdomains.txt);do
cat gospider/merge/* | grep -oP "http(s)?://((?i)(([a-zA-Z0-9]{1}|[_a-zA-Z0-9]{1}[_a-zA-Z0-9-]{0,61}[a-zA-Z0-9]{1})[.]{1})+)?$domain.*" | anew gourls.txt
done
cat gourls.txt | cut -d "]" -f 1 | grep = | grep -v -E '\.jpg|\.jpeg|\.gif|\.css|\.tif|\.tiff|\.png|\.ttf|\.woff|\.woff2|\.ico|\.pdf|\.svg|\.txt|\.js|\.json' | uro | anew gurls.txt
cat kurls.txt gaurls.txt hurls.txt gurls.txt | uro | anew allurls.txt
rm kurls.txt gaurls.txt hurls.txt gurls.txt
axiom-scan allurls.txt -m httpx -mc 200 -o liveurls.txt
axiom-exec 'cd /home/op/recon; git clone https://github.com/projectdiscovery/fuzzing-templates'
axiom-scan liveurls.txt -m nuclei-fuzz -o fuzzresults.txt
