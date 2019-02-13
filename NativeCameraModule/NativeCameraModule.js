import React from 'react';
import { StyleSheet, requireNativeComponent, UIManager, findNodeHandle, } from 'react-native';

const CameraView = requireNativeComponent('CameraModule')

export default class NativeCameraModule extends React.Component {

    constructor(props) {
        super(props)
    }

    _onTakePhoto = () => {
        if (this.camera) {
            UIManager.dispatchViewManagerCommand(
                findNodeHandle(this.camera),
                UIManager["CameraModule"].Commands.onCameraTakePhoto,
                []
            );
        }
    }

    _onNewImageTaken = (e) => {
        this.image = e.nativeEvent.image
    }

    render() {
        return <CameraView
            onImageReturn={ this.props.onImageReturn }//this._newImageTaken}
            ref={e => { this.camera = e }}
            style={[styles.container, this.props.style]}
            height={this.props.height}
            width={this.props.width}
        >{this.props.children}
        </CameraView>
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: 'stretch',
        justifyContent: 'center'
    }
})
