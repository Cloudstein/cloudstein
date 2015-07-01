# cloudstein
Web Application with a Docker Image build UI

Need to request a API key and secret from Github

git clone https://github.com/cloudstein

cd cloudstein/dockergui_appContainer_v5
./build

cd ../usercontainer
./build

docker images # should see two images "cloudstein" & "usercontainer"

need a mysql server

docker run --name cs-mysql -e MYSQL_ROOT_PASSWORD=hello123 -d mysql

docker run --privileged --name cs --link cs-mysql:mysql -e GITHUB_API_CLIENT_ID=< GITHUB CLIENT ID> -e GITHUB_API_CLIENT_SECRET=<GITHUB CLIENT API SECRET> -p 80:80 -d cloudstein

After this, the environment is setup done, go to the http://HOSTIP/admin, then input the password “Hellp!@#”, 
input the host's IP (client host ip). 

Then everything is done
