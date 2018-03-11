import React from 'react';
import { Text, View, StyleSheet } from 'react-native';

export default class HomeScreen extends React.Component {

  componentDidMount() {
    setTimeout(() => (this.props.navigation.navigate('Map')), 2000)
  }

  render() {
    return (
      <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
        <Text
          style={styles.bigblue}
        >
          Flatico
        </Text>
      </View>
    )
  }
}


const styles = StyleSheet.create({
  bigblue: {
    color: '#3B7CEC',
    fontWeight: 'bold',
    fontSize: 30,
  },
});
