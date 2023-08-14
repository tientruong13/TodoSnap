import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:task_app/component/todo_badge.dart';

class IconPicker extends StatefulWidget {
  final ValueChanged<IconData> onIconChanged;
  final IconData currentIconData;
  final Color highlightColor, unHighlightColor;

  final List<IconData> icons = [
    Icons.four_k,
    Icons.ac_unit,
    Icons.access_time,
    Icons.accessibility,
    Icons.accessible,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.account_box,
    Icons.account_circle,
    Icons.add_a_photo,
    Icons.add_call,
    Icons.add_comment,
    Icons.add_location,
    Icons.add_shopping_cart,
    Icons.airplanemode_active,
    Icons.airport_shuttle,
    Icons.assignment_turned_in,
    Icons.assistant,
    Icons.assistant_photo,
    Icons.atm,
    Icons.attach_file,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.av_timer,
    Icons.backup,
    Icons.battery_full,
    Icons.beach_access,
    Icons.book,
    Icons.bookmark,
    Icons.bookmark_border,
    Icons.broken_image,
    Icons.brush,
    Icons.build,
    Icons.business_center,
    Icons.cake,
    Icons.calendar_today,
    Icons.call,
    Icons.camera,
    Icons.camera_alt,
    Icons.cancel,
    Icons.chat,
    Icons.child_friendly,
    Icons.color_lens,
    Icons.colorize,
    Icons.comment,
    Icons.computer,
    Icons.contact_mail,
    Icons.contact_phone,
    Icons.devices,
    Icons.dock,
    Icons.drafts,
    Icons.drive_eta,
    Icons.edit,
    Icons.email,
    Icons.ev_station,
    Icons.event,
    Icons.face,
    Icons.fastfood,
    Icons.favorite,
    Icons.favorite_border,
    Icons.fingerprint,
    Icons.fitness_center,
    Icons.flag,
    Icons.flare,
    Icons.flight,
    Icons.folder,
    Icons.free_breakfast,
    Icons.g_translate,
    Icons.golf_course,
    Icons.group,
    Icons.headset,
    Icons.headset_mic,
    Icons.healing,
    Icons.hearing,
    Icons.help,
    Icons.highlight,
    Icons.home,
    Icons.hot_tub,
    Icons.hotel,
    Icons.https,
    Icons.image,
    Icons.insert_photo,
    Icons.invert_colors,
    Icons.iso,
    Icons.keyboard,
    Icons.keyboard_voice,
    Icons.kitchen,
    Icons.label,
    Icons.landscape,
    Icons.language,
    Icons.laptop,
    Icons.live_tv,
    Icons.local_airport,
    Icons.local_bar,
    Icons.local_cafe,
    Icons.local_car_wash,
    Icons.local_dining,
    Icons.local_drink,
    Icons.local_florist,
    Icons.local_gas_station,
    Icons.local_grocery_store,
    Icons.local_hotel,
    Icons.local_laundry_service,
    Icons.local_library,
    Icons.lock,
    Icons.mail,
    Icons.mail_outline,
    Icons.map,
    Icons.message,
    Icons.mic,
    Icons.mic_none,
    Icons.money_off,
    Icons.motorcycle,
    Icons.mouse,
    Icons.music_note,
    Icons.navigation,
    Icons.near_me,
    Icons.network_wifi,
    Icons.note,
    Icons.ondemand_video,
    Icons.pageview,
    Icons.palette,
    Icons.people,
    Icons.person,
    Icons.pets,
    Icons.phone,
    Icons.photo,
    Icons.pin_drop,
    Icons.pool,
    Icons.portrait,
    Icons.power,
    Icons.pregnant_woman,
    Icons.print,
    Icons.public,
    Icons.receipt,
    Icons.record_voice_over,
    Icons.redeem,
    Icons.restaurant,
    Icons.restaurant_menu,
    Icons.ring_volume,
    Icons.room,
    Icons.rowing,
    Icons.schedule,
    Icons.school,
    Icons.search,
    Icons.send,
    Icons.settings,
    Icons.settings_voice,
    Icons.share,
    Icons.shop,
    Icons.shopping_basket,
    Icons.shopping_cart,
    Icons.smartphone,
    Icons.smoking_rooms,
    Icons.sms,
    Icons.snooze,
    Icons.spa,
    Icons.spellcheck,
    Icons.stars,
    Icons.store,
    Icons.subway,
    Icons.supervisor_account,
    Icons.tablet_android,
    Icons.terrain,
    Icons.textsms,
    Icons.theaters,
    Icons.thumb_down,
    Icons.thumb_up,
    Icons.time_to_leave,
    Icons.timer,
    Icons.today,
    Icons.toys,
    Icons.traffic,
    Icons.train,
    Icons.tram,
    Icons.translate,
    Icons.tv,
    Icons.video_call,
    Icons.video_library,
    Icons.videocam,
    Icons.videogame_asset,
    Icons.visibility,
    Icons.volume_up,
    Icons.watch,
    Icons.wb_cloudy,
    Icons.wb_sunny,
    Icons.wc,
    Icons.weekend,
    Icons.work,
  ];

  IconPicker({
    required this.currentIconData,
    required this.onIconChanged,
    Color? highlightColor,
    Color? unHighlightColor,
  })  : this.highlightColor = highlightColor ?? Colors.red,
        this.unHighlightColor = unHighlightColor ?? Colors.black;

  @override
  State<StatefulWidget> createState() {
    return _IconPickerState();
  }
}

class _IconPickerState extends State<IconPicker> {
  late IconData selectedIconData;

  @override
  void initState() {
    selectedIconData = widget.currentIconData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: orientation == Orientation.portrait ? 300.0 : 300.0,
      height: orientation == Orientation.portrait ? 360.0 : 200.0,
      child: GridView.builder(
        itemBuilder: (BuildContext context, int index) {
          var iconData = widget.icons[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIconData = iconData;
                });
                widget.onIconChanged(iconData);
              },
              borderRadius: BorderRadius.circular(50.0),
              child: TodoBadge(
                id: iconData.hashCode.toString(),
                codePoint: iconData.codePoint,
                outlineColor: iconData == selectedIconData
                    ? widget.highlightColor
                    : widget.unHighlightColor,
                color: iconData == selectedIconData
                    ? widget.highlightColor
                    : widget.unHighlightColor,
                size: 8.w,
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: widget.icons.length,
      ),
    );
  }
}
