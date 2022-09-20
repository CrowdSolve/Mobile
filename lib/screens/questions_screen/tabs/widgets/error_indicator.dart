import 'package:flutter/material.dart';


class ErrorIndicator extends StatelessWidget {
  final VoidCallback? onTryAgain;

  const ErrorIndicator({Key? key, this.onTryAgain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = 'The application has encountered an unknown error.\n'
            'Please try again later.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            if (message != null)
              const SizedBox(
                height: 16,
              ),
            if (message != null)
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            if (onTryAgain != null)
              const SizedBox(
                height: 48,
              ),
            if (onTryAgain != null)
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: onTryAgain,
                  icon:  Icon(
                    Icons.refresh,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label:  Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
