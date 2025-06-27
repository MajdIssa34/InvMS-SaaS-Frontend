import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/api_key_cubit.dart';
import '../blocs/api_key_state.dart';

class ApiKeyScreen extends StatelessWidget {
  const ApiKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // When the screen is built, trigger the cubit to fetch the data.
    context.read<ApiKeyCubit>().fetchApiKeys();

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Key Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Implement create key dialog
            },
          ),
        ],
      ),
      body: BlocBuilder<ApiKeyCubit, ApiKeyState>(
        builder: (context, state) {
          if (state is ApiKeyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ApiKeyError) {
            return Center(child: Text(state.message));
          }
          if (state is ApiKeyLoaded) {
            if (state.apiKeys.isEmpty) {
              return const Center(child: Text('No API keys found. Create one!'));
            }
            return ListView.builder(
              itemCount: state.apiKeys.length,
              itemBuilder: (context, index) {
                final apiKey = state.apiKeys[index];
                return ListTile(
                  title: Text(apiKey.name),
                  subtitle: Text('Key Prefix: ${apiKey.keyPrefix}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      // TODO: Implement revoke key
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Click the + to add an API key.'));
        },
      ),
    );
  }
}