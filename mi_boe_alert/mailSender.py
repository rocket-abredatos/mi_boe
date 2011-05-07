SENDMAIL = "/usr/sbin/sendmail" # sendmail location

import os
import sys

mail=sys.argv[1]
texto=sys.argv[2]

p = os.popen("%s -t -w" % SENDMAIL, "w")
#p.write("To: alejandrogonzalezdiez@gmail.com\n")
p.write("To: "+ mail + "\n")
p.write("From: alertas@miboe.es\n")
p.write("Subject: test\n")
p.write("\n") # blank line separating headers from body
p.write(texto+"\n")
#p.write("some more text\n")
print "ESPERANDO"
sts = p.close()
if sts != 0:
    print "Sendmail exit status", sts
