import 'package:decapitalgrille/utils/common_services.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Core.backBut(context),
            pinned: true,
            snap: true,
            floating: true,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
              background: Image.asset(
                'images/app/decapital_auth_bg.png',
                fit: BoxFit.cover,
              ),
              collapseMode: CollapseMode.pin,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Core.loadThis(context),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
                return null;
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
