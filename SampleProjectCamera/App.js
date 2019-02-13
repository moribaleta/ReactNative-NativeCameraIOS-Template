/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import React, {Component} from 'react';
import {Platform, StyleSheet,Dimensions, Text,Button, View, Alert,Image} from 'react-native';
import NativeCamera from './NativeCameraModule/NativeCameraModule'
/* import NativeCameraModule from './NativeCameraModuleNativeModule' */

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' + 'Cmd+D or shake for dev menu',
  android:
    'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

type Props = {};
export default class App extends Component<Props> {

  constructor(props){
    super(props)
    this.image = null
  }


  _onPress = () => {
    if(this.camera) {
      this.camera._onTakePhoto()
    }
  }

  _newImageTaken = (e) => {
    this.image = e.nativeEvent.image
    Alert.alert(
      "hi",
      'My Alert Msg',
      [
        {text: 'Ask me later', onPress: () => console.log('Ask me later pressed')},
        {
          text: 'Cancel',
          onPress: () => console.log('Cancel Pressed'),
          style: 'cancel',
        },
        {text: 'OK', onPress: () => console.log('OK Pressed')},
      ],
      {cancelable: false},
    );
    this.forceUpdate()
  }


  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        {
          this.image ? <Image style={{width: 50, height: 50}} source={{uri: this.image}}/> : null
        }
        <Text style={styles.instructions}>hi</Text>
        <Button onPress={() => {this._onPress()}} title="take a photo"></Button>
        <NativeCamera  
          onImageReturn={this._newImageTaken}
          ref={e=>{this.camera = e}}
          style={styles.wrapper} 
          height={Dimensions.get('window').height} 
          width={Dimensions.get('window').width}>
        </NativeCamera> 
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'stretch',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  wrapper: {
    /* flex: 1,
    width: '100%',
    height: '100%', */
    flex:1,
    alignItems: 'stretch',
    flexDirection: 'column',
    justifyContent: 'center',
    borderWidth: 1,
  },
});
