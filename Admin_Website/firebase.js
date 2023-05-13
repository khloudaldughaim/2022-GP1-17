  // Import the functions you need from the SDKs you need
  //import { initializeApp } from "https://www.gstatic.com/firebasejs/9.13.0/firebase-app.js";
  // TODO: Add SDKs for Firebase products that you want to use
  // https://firebase.google.com/docs/web/setup#available-libraries

// import firebase from "firebase/app";
// import "firebase/auth";

  // Your web app's Firebase configuration
  const firebaseConfig = {
    apiKey: "AIzaSyAr1mN4YcMISQr10muc7xYj155Gliy8Krc",
    authDomain: "nozol-aadd3.firebaseapp.com",
    projectId: "nozol-aadd3",
    storageBucket: "nozol-aadd3.appspot.com",
    messagingSenderId: "842086655256",
    appId: "1:842086655256:web:703792101d41eae8696a6d"
  };

  // Initialize Firebase
  const app = firebase.initializeApp(firebaseConfig);
  const firestore = firebase.firestore();
  
// Initialize Firebase Authentication and get a reference to the service
//  const auth = firebase.auth();
