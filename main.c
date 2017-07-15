/* 
 * AVR project template - blinking LED example.
 * 
 * Copyright 2017 Patryk Nowak
 */

#include <avr/io.h>
#include <util/delay.h>


#define LED_PIN 5


int main(void)
{
	DDRB |= (1 << LED_PIN);

	for (;;)
	{
		PORTB |= (1 << LED_PIN);
		_delay_ms(60);

		PORTB &= ~(1 << LED_PIN);
		_delay_ms(940);
	}
}

