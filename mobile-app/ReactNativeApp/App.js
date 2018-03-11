import React from 'react';
import { StackNavigator } from 'react-navigation';

import MapScreen from './MapScreen.js'
import HomeScreen from './HomeScreen.js'

const RootStack = StackNavigator(
  {
    Home: {screen: HomeScreen},
    Map: {screen: MapScreen},
  },
  {initialRouteName: 'Home'}
);

export default class App extends React.Component {
  render() {
    return <RootStack />
  }
}
