function [  ] = notify_me( message, attachment, config)
%NOTIFY Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3
    config = struct();
    config.server = 'smtp.163.com';
    config.sender = 'gqwzx2004@163.com';
    config.password = 'm9w^25E*3XEVb*fY';
    config.smtp_auth = 'true';
    config.smtp_ssl = true;
    config.smtp_port = '465';
    config.recipient = 'guo.q@qq.com';
    config.subject = 'Matlab notify';
end

setpref('Internet','SMTP_Server',config.server);
setpref('Internet','E_mail',config.sender);
setpref('Internet','SMTP_Username',config.sender);
setpref('Internet','SMTP_Password',config.password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth',config.smtp_auth);
if config.smtp_ssl
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
end
props.setProperty('mail.smtp.socketFactory.port',config.smtp_port);
try
    sendmail(config.recipient,config.subject,message,attachment);
catch e
    fprintf(1, 'Sendmail failed: %s\n', e.message);
end
end

