import 'package:dars5/core/database_helper.dart';
import 'package:dars5/core/model/word_model.dart';
import 'package:dars5/di.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

class SqflitePage extends StatefulWidget {
  const SqflitePage({Key? key}) : super(key: key);

  @override
  State<SqflitePage> createState() => _SqflitePageState();
}

class _SqflitePageState extends State<SqflitePage> {
  final db = di.get<DatabaseHelper>();
  final controller = TextEditingController();
  var words = <WordModel>[];
  var isUz = true;

  @override
  void initState() {
    controller.addListener(() {
      search();
    });
    super.initState();
  }

  void search() {
    EasyDebounce.debounce(
      'my-debouncer',
      const Duration(milliseconds: 300),
      () async {
        if (isUz) {
          words = await db.findByUz(controller.text);
        } else {
          words = await db.findByEn(controller.text);
        }
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    EasyDebounce.cancel('my-debouncer');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SqflitePage: ${isUz ? "[uz->en]" : "[en->uz]"}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    // onChanged: (value) {
                    //
                    // },
                    scrollPadding: const EdgeInsets.all(0),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    // controller.text = "fdfgdf";
                    isUz = !isUz;
                    setState(() {});
                    search();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const Icon(
                    Icons.change_circle_outlined,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(builder: (context) {
                if (words.isEmpty) {
                  return const Placeholder();
                }
                return ListView.separated(
                  itemCount: words.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 18),
                  itemBuilder: (context, i) {
                    return Text(
                      isUz ? words[i].uz : words[i].en,
                      style: const TextStyle(fontSize: 32),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
