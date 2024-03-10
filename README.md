# Godot Firebase Tutorial sample project
**This is a sample project for the tutorial:**
- Basic authentication & cloud save: https://youtu.be/LnQG08Sbl7c
- Sign in with Google: https://youtu.be/CFJ6YujvPR8
- Realtime database: https://youtu.be/iE67zJ4_4BQ

The project is made on Godot 4.2, using the GodotFirebase plugin (https://github.com/GodotNuts/GodotFirebase).

### Starter template
The starter template contains a simple Game.tscn and Authentication.tscn scene for you to follow the tutorial.

### Completed project
This is the end result of the "Basic authentication & cloud save" tutorial. If you want to run it, remember to fill in the .env file in addons/godot-firebase.

### Sign in with Google sample
This is the end result of the "Sign in with Google" tutorial. If you want to run it, remember to fill in the .env file in addons/godot-firebase.

### Realtime database sample
This is the end result of the "Realtime database" tutorial.  If you want to run it, remember to fill in the .env file in addons/godot-firebase.

## Troubleshooting
If the project doesn't work for you, make sure that:
- The .env file is filled with your parameters (you can find it in your project settings on firebase console), and is in the correct folder (addons/godot-firebase/)
- You have Authentication (email/password) enabled on the firebase console
- You have a Firestore database created on the firebase console
  
For the "Sign in with Google" tutorial, make sure that:
- You have the "Google provider" enabled in the sign in method, on the Firebase console.
- You have the consent screen setup and published, on the Google cloud console (API & services).
- You have the OAuth client id ready, and copy-pasted the client id and client secret to your .env file.
- (Web builds) You have the added your redirect uri to the authorized redirect uri of the web client id, on the Google cloud console (API & serviices > Credentials).
- (Web builds) Check if the version of your GodotFirebase plugin has the fix for the missing "JavaScript" feature tag. If not, download the 4.x branch from the GitHub directly, or follow the workaround instruction in the video.

For the "Realtime database" tutorial, make sure that:
- You have created the Realtime Database on the firebase console.
- You have copied the database url from the console to the .env file.
- You have the security rules setup correctly. (The Test mode will only work until a date)
- You're using the correct path. It has to be the same in the script (...get_database_reference(path, fileter)) and the security rules (if you have it setup).
- You have the http-sse-client installed in your addons folder.
