import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pal/Constant/color.dart';

class RatingBuilder extends StatefulWidget {
  final double iconSize, itemExtent;
  final int itemCount;
  final ValueChanged<int> onChanged;
  final Color activeColor, inactiveColor;
  final List<IconData> iconList;
  RatingBuilder(
      {this.activeColor,
      this.inactiveColor,
      this.itemCount,
      this.onChanged,
      this.iconSize,
      this.iconList,
      this.itemExtent});
  @override
  _RatingBuilderState createState() => _RatingBuilderState();
}

class _RatingBuilderState extends State<RatingBuilder> {
  List<IconData> icon;
  List<Color> colorList;
  Color inactiveColor = AppColors.primaryColor.withOpacity(0.2);
  @override
  void initState() {
    setState(() {
      icon = widget.iconList ?? List.generate(widget.itemCount ?? 5, (index) {
        return widget.iconList ?? Icons.star_border;
      });
      colorList = List.generate(widget.itemCount ?? 5, (index) {
        return widget.inactiveColor ?? inactiveColor;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.iconSize != null ? widget.iconSize + 5 : 40,
      child: ListView.builder(
          itemCount: icon.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: widget.itemExtent ?? 40,
          itemBuilder: (BuildContext context, int index) {
            return IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 25,
              onPressed: () {
                if(index == 0 && colorList[0] == AppColors.primaryColor){
                  widget.onChanged(index);
                  for (int i = 0; i < icon.length; i++) {
                    setState(() {
                      colorList[i] = widget.inactiveColor ?? inactiveColor;
                      if(icon[i] == Icons.star_border){
                        icon[i] = Icons.star;
                      }
                    });
                  }
                } else {
                  widget.onChanged(index+1);
                  for (int i = 0; i < icon.length; i++) {
                    setState(() {
                      colorList[i] = widget.inactiveColor ?? inactiveColor;
                      if(icon[i] == Icons.star_border){
                        icon[i] = Icons.star;
                      }
                    });
                  }
                  for (int i = 0; i <= index; i++) {
                    setState(() {
                      colorList[i] = widget.activeColor ?? AppColors.primaryColor;
                      if(icon[i] == Icons.star_border){
                        icon[i] = Icons.star;
                      }
                    });
                  }
                }
              },
              color: colorList[index],
              icon: Icon(
                icon[index] ?? Icons.star_border,
                size: widget.iconSize ?? 35,
              ),
            );
          }),
    );
  }
}
