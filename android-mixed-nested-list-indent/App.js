import { StatusBar } from 'expo-status-bar';
import { SafeAreaView, ScrollView, StyleSheet, Text } from 'react-native';
import { EnrichedMarkdownText } from 'react-native-enriched-markdown';

// Nested lists whose marker type differs from their parent's. Expected (and
// what iOS draws): every nested marker keeps the usual gap before its text.
// Actual on Android: numbers and checkboxes under a bullet are drawn over
// their own text, and bullets under a number sit far from theirs.
const markdown = `- Python
  1. Django
  2. FastAPI

1. Ordered parent
   - Bullet child
   - Second bullet child

- Bullet parent
  - [ ] Unchecked task child
  - [x] Checked task child
`;

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.content}>
        <Text style={styles.title}>react-native-enriched-markdown 1.1.1</Text>
        <EnrichedMarkdownText markdown={markdown} flavor="github" />
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
