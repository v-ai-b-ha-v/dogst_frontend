import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class PetCard extends StatefulWidget {
  const PetCard({
    super.key,
    required this.level,
    required this.petName,
    required this.streak,
  });

  final int level;
  final String petName;
  final int streak;

  @override
  State<PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<PetCard> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.025,
        horizontal: width * 0.02,
      ),
      child: Center(
        child: Card(
          elevation: 5,
          shadowColor: Colors.cyan.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 22, 194, 233),
                  Color.fromARGB(255, 11, 106, 138),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: height * 0.25,
            width: width * 0.93,
            child: Stack(
              children: [
                Positioned(
                  height: height * 0.25,
                  top: height * 0.08,
                  left: width * 0.93 * 0.1,
                  child: Lottie.asset('assets/rocket.json'),
                ),

                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                          left: width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.petName,
                              style: GoogleFonts.play(
                                fontSize: height * 0.03,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: height * 0.02),

                            Text(
                              'Level ${widget.level.toString()}',
                              style: GoogleFonts.play(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              'Streak ${widget.streak.toString()} days',
                              style: GoogleFonts.play(
                                fontSize: height * 0.02,
                                fontWeight: FontWeight.w700,
                                color:
                                    (widget.streak == 0)
                                        ? Color.fromARGB(255, 238, 19, 4)
                                        : const Color.fromARGB(255, 1, 40, 3),
                              ),
                            ),
                          ],
                        ),
                      ),

                       Positioned(
                        top: height*0.25*0.2,
                        right: width*0.05,
                        width: width*0.3,
                        height: height*0.15,
                         child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          height: height*0.15,
                          width: width*0.4,
                          child: ClipRRect(
                            
                         borderRadius: BorderRadius.circular(16),
                         child: (widget.level != -1) ?
                         CachedNetworkImage(
                          imageUrl: 'https://ik.imagekit.io/m5ptxj0ar/level${widget.level}.webp',
                         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                         alignment: Alignment.centerRight,
                           height: height * 0.25 * 0.6,
                           fit: BoxFit.cover,
                         errorWidget: (context, url, error) => const Icon(Icons.error),
                         )
                         :SizedBox.shrink(),
                       ),
                         ),
                       )
                    
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
