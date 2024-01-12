# fleety

This is a machine test I have done which basically implements the graphQL api. It is a fleet management app.
It has the below functionlities:
1. Driver registration and login
2. Add and display driver's car details
3. Display driver's profile details
4. Fetching driver's current location and send to the server continously when driver select start sharing and stops when selected stop sharing.


   ps: I haven't concentrated in the UI part in this and didn't managed the location permission flows. So, for this to work properly you need to enable all the location permissions. (turn on app location permission and geolocation)

## Getting Started

If you want the generator to run one time and exits use
```
dart run build_runner build --delete-conflicting-outputs
```
