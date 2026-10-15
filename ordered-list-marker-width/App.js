import { StatusBar } from 'expo-status-bar';
import { SafeAreaView, ScrollView, StyleSheet, Text } from 'react-native';
import { EnrichedMarkdownText } from 'react-native-enriched-markdown';

// Ordered lists that reach three or four digits. Expected: every marker is
// complete. Actual: the marker column only fits "99.", so wider numbers are
// cut off at the leading edge.
const markdown = `98. Two digits
99. Two digits
100. Three digits
101. Three digits

A separate list:

998. Three digits
999. Three digits
1000. Four digits
1001. Four digits
      - Nested under a wide parent
`;

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.content}>
        <Text style={styles.title}>react-native-enriched-markdown 1.1.1</Text>
        <EnrichedMarkdownText markdown={markdown} />
      </ScrollView>
      <StatusBar style="auto" />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  content: { padding: 16, paddingTop: 48 },
  title: { fontSize: 13, color: '#666', marginBottom: 12 },
});
