# Kerberos.io Free Mobile script

This repository contains a simple bash script for [Kerberos.io](https://kerberos.io/) to send messages with [Free Mobile](http://mobile.free.fr/) in case of intrusion detection.

# Installation

Follow the official [Kerberos.io tutorial](https://doc.kerberos.io/2.0/machinery/Outputs/script).

# Configuration

Edit the `run.sh` file:

- `api_free_mobile_user`: the Free Mobile ID.
- `api_free_mobile_pass`: the Free Mobile Pass.

[How to get my Free Mobile ID and Pass?](https://www.freenews.fr/freenews-edition-nationale-299/free-mobile-170/nouvelle-option-notifications-par-sms-chez-free-mobile-14817) (in french).

- `api_free_mobile_number`: your mobile number. *Optional. For future use perhaps?*
- `message`: the message you want to receive in case of intrusion.
- `path_to_image_directory`: path to the image.
- `port`: port of the server.

The `pathToImage` will be `http://your_ip:port/path_to_image_directory/imageName.jpg`. *your_ip is your public IP.*

- `https_enabled`: if `pathToImage` must start by `http` or `https`.

### Customize the message

You can insert the following variables in your message:

|Text| Signification |
|:--:|--|
| timestamp | The timestamp corresponding to the detection time. E.g. `1486049622` |
| datetime | The datetime corresponding to the detection time. E.g. `Thu Feb 2 16:33:42 STD 2017`| 
| microseconds | **?** E.g. `6-161868` | 
| token |  **?** E.g. `344` |
| instanceName | Name of the instance linked to the detection. E.g. `front door` |
| regionCoordinates | Coordinates of the region where a movement was detected. E.g. `[308,250,346,329]` |
| numberOfChanges | **?** E.g. `194` |
| pathToImage | Path to the related image. E.g. `http://192.168.0.1/data/1486049622_6-161868_frontdoor_308-250-346-329_194_344.jpg` |

To integrate a variable into the message, simply write in the message `__{variable}__`. E.g. `__datetimetime__`.

**Note**: To go to the line in the message, you must type `\n `.

# Test

In order to test the script:
```
./run.sh '{"regionCoordinates":[308,250,346,329],"numberOfChanges":194,"timestamp":"1486049622","microseconds":"6-161868","token":344,"pathToImage":"1486049622_6-161868_frontdoor_308-250-346-329_194_344.jpg","instanceName":"frontdoor"}'
```

