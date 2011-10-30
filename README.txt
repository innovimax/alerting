Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.


SETUP INSTRUCTIONS:

You can run the setup of the sample application as any user 
with the alert-admin role or as an admin of the server.

The sample application assumes you are using the database named Documents 
and the content processing domain named Default Documents.  Make sure that
you have not removed or renamed them.

Perform these 3 steps if you plan to use the app (use - not install) as
someone other than an admin user.  You may consider providing all or 
some of these privileges to the alert-user role for simplicity.  Steps:

  1.  Be sure to give the URI privileges for the URIs where logs for the log
      action and the aggregate email action are inserted to any user who 
      you wish to allow to use those actions (or add these to the 
      alert-user role):
 
          http://marklogic.com/demo/inbox-log/ 
          http://marklogic.com/demo/aggregate-log/

  2.  Be sure to give URI privileges for any URIs that will be used in 
      the content creation application page and for any URIs used as CPF
      domain scope URIs (you will most likely be loading data through
      WebDAV to these URIs).  For the URIs created in the Manage Content
      part of the application, create a URI Privilege for the following URI
      and assign this URI privilege to all users of the sample application
      (or add this to the alert-user role):

          /web/content/

  3.  If you would like a user to be able to create rules with the email
      or SMS actions, be sure to give them the following execute privileges
      (or add these to the alert-user role):

          http://marklogic.com/xdmp/privileges/xdmp-add-response-header
          http://marklogic.com/xdmp/privileges/xdmp-email

      If the application user does not have these execute privilege, then 
      the choices for actions using email or SMS will be grayed out for 
      them.

Set up CPF with the following 3 steps through the Admin UI (or
programmatically):

  1. Install CPF for your desired database.  Be sure to enable conversion
     if you have conversion licensed.

          Configure
          -> Databases
             -> Documents (or another desired DB)
               -> Content Processing
                 -> Install (found as a tab)
                   -> Install(button)

  2. Add the alerting pipeline to the CPF domain

          Configure
          -> Databases
            -> Documents (or another desired DB)
              -> Content Processing
                -> Domains
                  -> Default Documents
                    -> Pipelines
                      -> Alerting (check the box)
                        -> Ok (button)

  3. Specify the URI of the domain scope for the CPF domain.  Be sure to set
     it to something other than "/" or "/web/" or "/web/content/", such as
     "/mycontent/".  The triggers for alerting will trigger on documents
     written to "/web/content/", so you do not want both CPF and triggers to 
     act upon the same documents.

          Configure
          -> Databases
            -> Documents (or another desired DB)
              -> Content Processing
                -> Domains
                  -> Default Documents
                    -> Domain Scope (subsection of page)
                      -> URI (form text field)
                        -> Ok (button)

A few additional basic steps:

  1. Point an HTTP server at the directory

          MARKLOGIC_INSTALL_ROOT/Samples/alerting/ 

     with all the default setting for creating an HTTP server.

  2. Visit http://localhost:8030/ where 'localhost' is the name of your
     machine and '8030' is the port number of the HTTP server created in the
     previous step (you don't need to use 8030 - any available port is fine).

  3. You will be shown a screen prompting you to setup the alerting
     configuration. Click OK.

  4. You will be shown a screen prompting you to setup triggers for alerting.
     Click OK or Skip.  You must choose OK in Step 4 or Step 5 or both.

  5. You will be shown a screen prompting you to setup CPF for alerting.
     Click OK of Skip.  You must choose OK in Step 4 or Step 5 or both.

  6. You will be shown a screen prompting you to setup the alerting actions.
     Click OK.

  7. You will be redirected to http://localhost:8030/demo/ where you can
     start using the application.

  8. Be sure to set default permissions for read/insert/update (used in
     document creation) for all users of the application who will create or 
     load content (do this for admin users too if you plan to use the app as 
     an admin).  This step is only necessary for users of the application, 
     not administrators who perform the set up process.

     You may desire to give default permissions to the alert-user role for
     simplicity, if you plan to use the app only as an alert-user.  Every
     user of the sample app should  either have the role admin, alert-admin
     or alert-user.



OPTIONAL SETUP INSTRUCTIONS:

If you would like the logs for the log action or the logs for the aggregate
email action to be protected, you may desire to make a protected collection
for the URIs 

    http://marklogic.com/demo/inbox-log/ and
    http://marklogic.com/demo/aggregate-log/

respectively. However, this is not necessary.



USAGE INSTRUCTIONS:

You can use the sample application as any user with the alert-user role 
or the alert-admin role or as an admin of the server.

The 'Rules' tab displays all rules for the current user.

Click the 'Create/Edit Rule' tab to create new rules.

When creating a rule, if additional information is required for an action,
then form fields will appear to prompt the user for the information (ex: 
an email address for the email action) when the drop-down selection is
changed. 

The 'Inbox' tab displays logs created from rules with the 'log' action
("Log an alert match to the database" in the action drop-down menu).

Near the bottom of the 'Rules' tab, you will see a link that reads "Manage
Content". Click the link to be taken to a secondary utility for creating,
viewing, and searching through basic content.  The content created here
causes alerts to fire on matching rules. 

Content that is passed through CPF will also be available for view here.  
You can load .doc and .pdf files through a WebDav client, and if they are 
in the directory that you specified for the domain scope (Step #3 of 
setting up CPF), then those documents will be processed with CPF and you 
will get alerted on these documents.  Be sure that you have set 
permissions for the directory specified for the WebDav server that will be
used to load content (in case you want to connect to that WebDav server 
as a non-admin).

ADMINISTRATING AGGREGATE EMAIL:

If a user chooses an action of aggregate email for their rule(s), then
the alerts for these rules will not be sent to the user until an admin 
user initiates the sending of aggregate emails. All the emails for the 
same rule will be combined together into a single email.  An admin user 
can kick off the sending of aggregate emails by visiting the following 
URL in a browser or making an HTTP GET request of the URL:

http://localhost:8010/admin/aggregate.xqy?start=2008-09-10T16:05:24.454-07:00&end=2008-09-10T16:15:24.454-07:00

Same URL broken into pieces:

http://localhost:8010/
admin/aggregate.xqy?
start=2008-09-10T16:05:24.454-07:00&
end=2008-09-10T16:15:24.454-07:00

Replace "localhost" with your machine name and replace "8010" with the 
port number where the sample application is running.  Edit the 'start'
and 'end' parameters to specify the range of time that should be used
in determining which alerts to include in the emails.

An example of administrating aggregated email alerts:
Let's say you would like to send daily aggregate emails.  You would set
the start time to 24 hours ago and set the end time to the current time.
You could set up a Linux cron job which called wget for the appropriate
URL once every day.
