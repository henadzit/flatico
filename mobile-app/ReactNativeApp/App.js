import React from 'react';
import { StyleSheet, Text, View, Button, Alert } from 'react-native';

import MapView, { Marker } from 'react-native-maps'

const LATITUDE_DELTA = 0.2;
const LONGITUDE_DELTA = 0.1;

export default class App extends React.Component {
  state = {
    region: {
      latitude: 53.904540,
      longitude: 27.561524,
      latitudeDelta: LATITUDE_DELTA,
      longitudeDelta: LONGITUDE_DELTA,
    },
    currentLocation: null
  }

  componentDidMount() {
    console.log('Component did mount');
    this.getCurrentPosition();
  }

  setRegion(region) {
    if(this.state.ready) {
      setTimeout(() => this.map.mapview.animateToRegion(region), 10);
    }

    this.setState({ region, currentLocation: { latitude: region.latitude, longitude: region.longitude }} )
  }

  getCurrentPosition() {
    try {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const region = {
            latitude: position.coords.latitude,
            longitude: position.coords.longitude,
            latitudeDelta: LATITUDE_DELTA,
            longitudeDelta: LONGITUDE_DELTA,
          };
          this.setRegion(region);
        },
        (error) => {
          Alert.alert(error.message)
        }
      );
    } catch(e) {
      alert(e.message || "");
    }
  };

  render() {
    const marker = this.state.currentLocation ? (<Marker coordinate={ this.state.currentLocation } title="Координаты квартиры" />) : null

    return (
    <View style={styles.container}>
      <Button
        title="Next"
        color="#3B7CEC"
        onPress={() =>
          navigate('Profile', { name: 'Jane' })
        }
      />
      <MapView
        style={{ left:0, right: 0, top:0, bottom: 0, position: 'absolute' }}
        initialRegion={this.state.region}
      >
        { marker }
      </MapView>
    </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
