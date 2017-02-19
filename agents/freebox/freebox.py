
#
# Minimalistic freebox connection to use the fbx API
#
#


import urllib2,hmac,json,hashlib,time

class FbxCnx:
    def __init__(self,host="mafreebox.free.fr"):
        self.host=host

    def register(self,appid,appname,devname):
        data={"app_id": appid,"app_name": appname,"device_name": devname}
        r=self._com("login/authorize/",data)["result"]
        trackid,token=r["track_id"],r["app_token"]
        s="pending"
        while s=="pending":
            s=self._com("login/authorize/%s"%trackid)["result"]["status"]
            time.sleep(1)
        return s=="granted" and token

    def _com(self,method,data=None,headers={}):
        url = "http://"+self.host+"/api/v3/"+method
        if data: data = json.dumps(data)
        return json.loads(urllib2.urlopen(urllib2.Request(url,data,headers)).read())

    def _mksession(self):
        challenge=self._com("login/")["result"]["challenge"]
        data={
          "app_id": self.appid,
          "password": hmac.new(self.token,challenge,hashlib.sha1).hexdigest()
        }
        return self._com("login/session/",data)["result"]["session_token"]

class FbxApp(FbxCnx):
    def __init__(self,appid,token,session=None,host="mafreebox.free.fr"):
        FbxCnx.__init__(self,host)
        self.appid,self.token=appid,token
        self.session=session if session else self._mksession()

    def com(self,method,data=None):
        return self._com(method,data,{"X-Fbx-App-Auth": self.session})

    def dir(self,path='/Disque dur/'):
        return self.com( "fs/ls/" + path.encode("base64") )


