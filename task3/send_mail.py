import smtplib  
import email.utils
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import sys
import string
comp=sys.argv[1]
#print (len(sys.argv))
#print (comp)
# Replace sender@example.com with your "From" address. 
# This address must be verified.
SENDER = 'alerts@aerodygital.com'  
SENDERNAME = 'Alerts_awsprac88'

# Replace recipient@example.com with a "To" address. If your account 
# is still in the sandbox, this address must be verified.
RECIPIENT  = 'awsprac88@gmail.com'

# Replace smtp_username with your Amazon SES SMTP user name.
USERNAME_SMTP = "AKIARYR62OX2FL2WODEY"

# Replace smtp_password with your Amazon SES SMTP password.
PASSWORD_SMTP = "BM5EnbwQLJ1EzSQpeaGMiCPl3U7dnROfLKgZqTVuHFFY"

# (Optional) the name of a configuration set to use for this message.
# If you comment out this line, you also need to remove or comment out
# the "X-SES-CONFIGURATION-SET:" header below.
#CONFIGURATION_SET = "ConfigSet"

# If you're using Amazon SES in an AWS Region other than US West (Oregon), 
# replace email-smtp.us-west-2.amazonaws.com with the Amazon SES SMTP  
# endpoint in the appropriate region.
#HOST = "email-smtp.us-west-2.amazonaws.com"
HOST = "email-smtp.ap-southeast-1.amazonaws.com"
PORT = 587

# The subject line of the email.
SUBJECT = 'AWS- %s' % comp

# The email body for recipients with non-HTML email clients.
BODY_TEXT = "AWS web server - %s 456" % comp
#             "This email was sent through the Amazon SES SMTP "
#             "Interface using the Python smtplib package."
#            )

# The HTML body of the email.
BODY_HTML = """<html>
<head></head>
<body>
  <h1>AWS web server - %s</h1>
  <p>This email was sent with Amazon SES using the
    <a href='https://www.python.org/'>Python</a>
    <a href='https://docs.python.org/3/library/smtplib.html'>
    smtplib</a> library.</p>
</body>
</html>
            """ % comp

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = SUBJECT
msg['From'] = email.utils.formataddr((SENDERNAME, SENDER))
msg['To'] = RECIPIENT
# Comment or delete the next line if you are not using a configuration set
#msg.add_header('X-SES-CONFIGURATION-SET',CONFIGURATION_SET)

# Record the MIME types of both parts - text/plain and text/html.
part1 = MIMEText(BODY_TEXT, 'plain')
part2 = MIMEText(BODY_HTML, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
msg.attach(part1)
msg.attach(part2)

# Try to send the message.
try:  
    server = smtplib.SMTP(HOST, PORT)
    server.ehlo()
    server.starttls()
    #stmplib docs recommend calling ehlo() before & after starttls()
    server.ehlo()
    server.login(USERNAME_SMTP, PASSWORD_SMTP)
    server.sendmail(SENDER, RECIPIENT, msg.as_string())
    server.close()
# Display an error message if something goes wrong.
except Exception as e:
    print ("Error: ", e)
else:
    print ("Email sent!")
