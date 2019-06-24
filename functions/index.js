const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

//listen for call in database and then trigger a push notifications
exports.observeCalling = functions.database.ref('/calling/{uid}/{callingId}').onCreate((snapshot,context) => {

      const uppercase = "hello";
      var uid = context.params.uid;
      var callingId = context.params.callingId;
      console.log('User:' + uid + ' is calling ' + callingId);

//configure fcm token to send push notifications
      return admin.database().ref('/users/' + callingId).once('value', snapshot => {
        var userWeAreCalling = snapshot.val();

        return admin.database().ref('/users/' + uid).once('value', snapshot => {
          var userDoingCalling = snapshot.val();

          var payload = {
            notification:{
              title:"Someone is attempting to call you~",
              body: userDoingCalling.username +  ' wants to call you!'
            },
            data:{
              "callerId": userDoingCalling.uid
            },
          };

          admin.messaging().sendToDevice(userWeAreCalling.token, payload).then(function(response){
            console.log("succesfully send message:", response);
          })
          .catch(function(errror){
            console.log("Error sending message:",error);
          });
        })

        })
      return snapshot.ref.parent.child('uppercase').set(uppercase);
    });

exports.observeCallResponse = functions.database.ref('/callResponse/{callerId}/{uid}').onCreate((snapshot, context) => {
  var callerId = context.params.callerId;
  var uid = context.params.uid;

  console.log('User' + callerId + 'is calling' + uid);

  return admin.database().ref('/users/' + callerId).once('value',snapshot => {
    var userDoingCalling = snapshot.val();

    return admin.database().ref('/users/' + uid).once('value', snapshot => {
      var userWeAreCalling = snapshot.val();

      var payload = {
        "aps" : {
        "content-available" : 1
        },
        "callerId" : callerId.uid
      };

      admin.messaging().sendToDevice(userDoingCalling.token, payload).then(function(response){
        console.log("succesfully send message:", response);
      })
      .catch(function(errror){
        console.log("Error sending message:",error);
      });


    })
  })


})

exports.sendNotifications = functions.https.onRequest((req,res) => {
  res.send("attempting to send notifications");
  console.log("LOGGER --- Attmepting to send notifications...");

  var uid = 'njHFYEZ5QpRTn6RKefpmNm1wnky1';

  return admin.database().ref('/users/' + uid).once('value',snapshot => {
    var user = snapshot.val();
    console.log("User username:" + user.username + "fcmToken:" + user.token);

    var payload = {
      notification:{
        title:"notification title",
        body: "message body"
      }
    }

    admin.messaging().sendToDevice(user.token, payload).then(function(response){
      console.log("succesfully send message:", response);
    })
    .catch(function(errror){
      console.log("Error sending message:",error);
    })
  })
  // var fcmToken = "cPc46R2C_Xk:APA91bEaj_pEhMa_Wg4eDz8mUAOZkPPTa2Qzr7ueI3jX6HYHFkHvS211PnDKkcaLPWtZIC5CfyhMllKVjhg_sKV7i2F5nOSFbhAp2J8TpNnQa9Lotut4MObr-sTS0wgJkbRdU0OSHbDN";
  //

  //   data:{
  //     score:"850",
  //     time:"2:45"
  //   }
  // };
  //

})
