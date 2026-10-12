"""Append the exact 1.7.24 MSIX to Sword’s existing pending Store draft, preserving its metadata."""
import copy, hashlib, json, os, urllib.parse, urllib.request, zipfile, xml.etree.ElementTree as ET
from pathlib import Path
PRODUCT="9P93XHHFP6H3"; DRAFT="1152921505702101034"; IDENTITY="YahwehsPeople.YahwehsSword"
VERSION="1.7.24.0"; PUBLISHER="CN=C4997401-2CEE-44B6-9803-4775768C89A5"
PACKAGE="yahwehs_sword.msix"; SHA256="a142b871f746ca6d1429843edeffd33b37182e38bf152afc808bdf298702f0a7"
BASE="https://manage.devcenter.microsoft.com/v1.0/my/applications/"+PRODUCT

def api(url, method="GET", payload=None, headers=None):
 data=None if payload is None else json.dumps(payload).encode()
 req=urllib.request.Request(url,data=data,method=method,headers={"Content-Type":"application/json",**(headers or {})})
 try:
  with urllib.request.urlopen(req,timeout=90) as response:
   raw=response.read(); return json.loads(raw) if raw else {}
 except Exception as error:
  if isinstance(error, urllib.error.HTTPError): raise SystemExit("Microsoft API "+method+" "+urllib.parse.urlsplit(url).path+" HTTP "+str(error.code)) from None
  raise

def main():
 import urllib.error
 p=Path("build/windows/x64/runner/Release")/PACKAGE
 if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest()!=SHA256: raise SystemExit("Exact retained package SHA mismatch")
 with zipfile.ZipFile(p) as z:
  root=ET.fromstring(z.read("AppxManifest.xml")); ident=root.find("{http://schemas.microsoft.com/appx/manifest/foundation/windows10}Identity")
 if ident is None or (ident.get("Name"),ident.get("Version"),ident.get("ProcessorArchitecture"),ident.get("Publisher"))!=(IDENTITY,VERSION,"x64",PUBLISHER): raise SystemExit("Package identity/version/publisher/architecture mismatch")
 form=urllib.parse.urlencode({"grant_type":"client_credentials","client_id":os.environ["MS_CLIENT"],"client_secret":os.environ["MS_SECRET"],"resource":"https://manage.devcenter.microsoft.com"}).encode()
 token_url="https://login.microsoftonline.com/"+os.environ["MS_TENANT"]+"/oauth2/token"
 with urllib.request.urlopen(urllib.request.Request(token_url,data=form),timeout=30) as r: headers={"Authorization":"Bearer "+json.load(r)["access_token"]}
 app=api(BASE,headers=headers)
 if app.get("id")!=PRODUCT or app.get("packageIdentityName")!=IDENTITY: raise SystemExit("Wrong Store product")
 pending=app.get("pendingApplicationSubmission")
 if not pending or pending.get("id")!=DRAFT: raise SystemExit("Different/no pending submission; preserve it")
 url=BASE+"/submissions/"+DRAFT; sub=api(url,headers=headers)
 if sub.get("id")!=DRAFT or sub.get("status")!="PendingCommit" or sub.get("targetPublishMode")!="Immediate": raise SystemExit("Draft status or automatic publication changed")
 if any(x.get("version")==VERSION or x.get("fileName")==PACKAGE and x.get("fileStatus")=="PendingUpload" for x in sub.get("applicationPackages",[])): raise SystemExit("1.7.24 package already staged; no duplicate")
 # Require and retain the known prior uploaded package. Refuse unexpected package-set changes.
 old=[x for x in sub.get("applicationPackages",[]) if x.get("fileStatus")=="Uploaded"]
 if not old or not any(x.get("version")=="1.7.22.0" for x in old): raise SystemExit("Expected prior 1.7.22 uploaded package missing; no change")
 updated=copy.deepcopy(sub); updated.setdefault("applicationPackages",[]).append({"fileName":PACKAGE,"fileStatus":"PendingUpload","minimumDirectXVersion":"None","minimumSystemRam":"None"})
 saved=api(url,"PUT",updated,headers)
 if saved.get("id")!=DRAFT: raise SystemExit("Draft save identity mismatch")
 saved=api(url,headers=headers)
 entries=[x for x in saved.get("applicationPackages",[]) if x.get("fileName")==PACKAGE and x.get("fileStatus")=="PendingUpload"]
 if len(entries)!=1: raise SystemExit("Pending package entry readback failed")
 blob=saved.get("fileUploadUrl",""); parsed=urllib.parse.urlsplit(blob)
 if parsed.scheme!="https" or not (parsed.hostname or "").endswith(".blob.core.windows.net"): raise SystemExit("Unexpected Microsoft upload host")
 import tempfile
 with tempfile.TemporaryDirectory() as d:
  zipp=Path(d)/"packages.zip"
  with zipfile.ZipFile(zipp,"w",zipfile.ZIP_DEFLATED) as z: z.write(p,PACKAGE)
  req=urllib.request.Request(blob,data=zipp.read_bytes(),method="PUT",headers={"x-ms-blob-type":"BlockBlob","Content-Type":"application/zip"})
  with urllib.request.urlopen(req,timeout=600) as r:
   if r.status!=201: raise SystemExit("Package storage rejected ZIP")
 # Storage proof is a separate readback; never expose its SAS URL.
 with urllib.request.urlopen(urllib.request.Request(blob,method="HEAD"),timeout=60) as r: length=int(r.headers.get("Content-Length","0"))
 if not 0<length<512*1024*1024: raise SystemExit("Staged ZIP size missing/out of bounds")
 import tempfile
 with tempfile.TemporaryFile() as f:
  digest=hashlib.sha256(); count=0
  with urllib.request.urlopen(blob,timeout=600) as r:
   while b:=r.read(1024*1024): f.write(b);digest.update(b);count+=len(b)
  if count!=length: raise SystemExit("Staged ZIP length mismatch")
  f.seek(0)
  with zipfile.ZipFile(f) as z:
   fs=[x for x in z.infolist() if not x.is_dir()]
   if len(fs)!=1 or fs[0].filename!=PACKAGE: raise SystemExit("Unexpected staged ZIP contents")
   with z.open(PACKAGE) as q: got=hashlib.sha256(q.read()).hexdigest()
 if got!=SHA256: raise SystemExit("Staged package readback SHA mismatch")
 print(json.dumps({"product":PRODUCT,"submission":DRAFT,"status":saved.get("status"),"targetPublishMode":saved.get("targetPublishMode"),"package":PACKAGE,"packageSha256":got,"zipBytes":count,"zipSha256":digest.hexdigest(),"stagedVerified":True,"reviewSubmitted":False}))
if __name__=="__main__":
 import urllib.error
 main()
