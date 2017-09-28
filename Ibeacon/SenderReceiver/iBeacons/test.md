<h2>How to test this...</h2>

Use the below app.js file.  

~~~
var win = Titanium.UI.createWindow({  
    backgroundColor:'#fff',layout:'vertical'
});

var btnAuthorization = Titanium.UI.createButton({
    title:'Authorization Check', left:25,right:25, top:80
});
win.add(btnAuthorization);

var btnGeoTest = Titanium.UI.createButton({
    title:'Test Geo', left:25,right:25, top:45
});
win.add(btnGeoTest);

Ti.Geolocation.addEventListener('authorization',function(e){
	Ti.API.info('authorization event:' + JSON.stringify(e));
});

function printAuthorizedResults(authorization){

	Ti.API.info('Authorization: '+authorization);

	if (authorization == Ti.Geolocation.AUTHORIZATION_UNKNOWN) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_UNKNOWN";
	}
	
	if (authorization == Ti.Geolocation.AUTHORIZATION_DENIED) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_DENIED";
	}	
	if (authorization == Ti.Geolocation.AUTHORIZATION_RESTRICTED) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_DENIED";
	}	
	if (authorization == Ti.Geolocation.AUTHORIZATION_AUTHORIZED) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_AUTHORIZED";
	}	
	if (authorization == Ti.Geolocation.AUTHORIZATION_ALWAYS) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_ALWAYS";
	}	
	if (authorization == Ti.Geolocation.AUTHORIZATION_WHEN_IN_USE) {
		return "Authorization = Ti.Geolocation.AUTHORIZATION_WHEN_IN_USE";
	}				
	
	return "Error: No authorization value found";
}

btnAuthorization.addEventListener('click',function(d){
	alert(printAuthorizedResults(Ti.Geolocation.locationServicesAuthorization));
});


btnGeoTest.addEventListener('click',function(d){
	Ti.Geolocation.getCurrentPosition(function(e)
	{
		if (!e.success || e.error){
			Ti.API.info("Code translation: "+translateErrorCode(e.code));
			alert('error ' + JSON.stringify(e.error));
			return;
		}

		var longitude = e.coords.longitude;
		var latitude = e.coords.latitude;
		var altitude = e.coords.altitude;
		var heading = e.coords.heading;
		var accuracy = e.coords.accuracy;
		var speed = e.coords.speed;
		var timestamp = e.coords.timestamp;
		var altitudeAccuracy = e.coords.altitudeAccuracy;
		Ti.API.info('speed ' + speed);

		Titanium.API.info('geo - current location: ' + new Date(timestamp) + ' long ' + longitude + ' lat ' + latitude + ' accuracy ' + accuracy);
	});	
});
win.open();
~~~