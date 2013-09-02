#ifndef AC97_H_
#define AC97_H_

#define MIN_OUTPUT_VOLUME	0
#define MAX_OUTPUT_VOLUME	32

void do_ac97_init(void);
void set_output_volume(int vol);


#endif /* AC97_H_ */
