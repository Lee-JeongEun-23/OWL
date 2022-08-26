importScripts('https://www.gstatic.com/firebasejs/7.6.2/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/7.6.2/firebase-messaging.js');



var firebaseConfig = {
        apiKey: "AIzaSyCUWhwHawfZnngksqB7RstHZJVC_fQloeg",
        authDomain: "owl-chat-c27f1.firebaseapp.com",
        databaseURL: "https://owl-chat-c27f1.firebaseio.com",
        projectId: "owl-chat-c27f1",
        storageBucket: "owl-chat-c27f1.appspot.com",
        messagingSenderId: "626219367568",
        appId: "1:626219367568:web:84d90164e32b237822ac15",
        measurementId: "G-7FX553N3RH"
      };
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    // Customize notification here
    const notificationTitle = 'Background Message Title';
    const notificationOptions = {
        body: 'Background Message body.',
        icon: '/firebase-logo.png'
    };

return self.registration.showNotification(notificationTitle,
    notificationOptions);
});

self.addEventListener('push', function(event) { 
	const payload = event.data.json(); 
	const title = payload.notification.title; 
	const options = { 
			body: payload.notification.body, 
			icon: payload.notification.icon, 
			data: payload.notification.click_action 
			}; 
	
	event.waitUntil(self.registration.showNotification(title, options)); 
	}); 


self.addEventListener('notificationclick', function(event) { 
	console.log(event.notification); 
	event.notification.close(); 
	event.waitUntil( 
			clients.openWindow(event.notification.data) 
			); 
	});


	
	
	
	