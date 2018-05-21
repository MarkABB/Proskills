#include "stdafx.h"
#include <stdio.h>
#include "string.h"
#include "stdarg.h"
#include "stdlib.h"
#include "time.h"

typedef enum S {CLUBS, DIAMONDS, HEARTS, SPADES} SUIT;
char suits[][10] = {"CLUBS", "DIAMONDS", "HEARTS", "SPADES"};

typedef enum F {TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE} FACE;
char faces[][10] = {"TWO", "THREE", "FOUR", "FIVE", "SIX", "SEVEN", "EIGHT", "NINE", "TEN", "JACK", "QUEEN", "KING", "ACE"};

typedef struct
{
	SUIT suit; 
	FACE face;
} card;

typedef struct
{
	card cards[5];
} hand;

// function deals a random hand of cards - BUT .... same card CANNOT be dealt twice!
// so if same card already in the hand, you would need to draw again
hand dealHand(hand handsDealt[], int numHandsDealt);

// returns pointer to string containing, for example, "ACE of HEARTS"
char * printCard(card aCard);

// compares the FACE values of two cards (TWO is lowest, ACE is highest)
// returns pointer to string containing name of winner: "You" or "Dealer" (or "Draw" if the face values are the same)
char * compareCards(card yourCard, card dealersCard);

// returns true if the hand contains four ACES
bool fourAces(hand aHand);

void main()
{
	int i = 0;
	hand myHand, dealersHand;
	int seed = time(NULL);
	srand(seed);
	hand hands[10];

	myHand = dealHand(hands, 0);
	hands[0] = myHand;

	dealersHand = dealHand(hands, 1);

	// here you are just comparing each card one at a time in the two hands
	while(i<5)
	{
		printf("card#%d: %s (you) vs. %s (dealer). Winner: %s \n", i+1, printCard(myHand.cards[i]), printCard(dealersHand.cards[i]),  compareCards(myHand.cards[i], dealersHand.cards[i]));
		i++;
	}

	// now try to deal 4 Aces !
	while(1)
	{
		myHand = dealHand(hands,0);
		if (fourAces(myHand)) break;
		i++;
	}
	// print out how many hands it took to find 4 aces
	printf ("\n\n4 aces found after %d hands \n\n\n", i);
}

char * compareCards(card yourCard, card dealersCard)
{
	char * sptr;
	sptr = (char *)malloc(10*sizeof(char));

	if (yourCard.face > dealersCard.face)
	{
		strcpy(sptr, "You");
	}
	else if (dealersCard.face > yourCard.face)
	{
		strcpy(sptr, "Dealer");
	}
	else
	{
		strcpy(sptr, "Draw");
	}

	return sptr;
}

char * printCard(card aCard)
{
	char * sptr;
	sptr = (char *)malloc(20*sizeof(char));
	sprintf (sptr, "%s of %s",faces[aCard.face], suits[aCard.suit]);
	return sptr;
}

hand dealHand(hand handsDealt[], int numHands)
{
	int i, n;
	int found = 0;
	hand newHand;
	int ncards = 0;

	SUIT newSuit;
	FACE newFace;

	while (ncards < 5)
	{
		newSuit = (SUIT)(rand()%4);
		newFace = (FACE)(rand()%13);

		// check in cards dealt already in this hand
		for (i=0;i<ncards;i++)
		{
			if ((newHand.cards[i].suit == newSuit) && (newHand.cards[i].face == newFace)) found = 1;
		}

		// check in cards dealt in previous hands
		for (n=0;n<numHands;n++)
		{
			for (i=0;i<5;i++)
			{
				if ((handsDealt[n].cards[i].suit == newSuit) && (handsDealt[n].cards[i].face == newFace)) found = 1;
			}
		}

		if (found == 0)
		{
			newHand.cards[ncards].suit = newSuit;
			newHand.cards[ncards].face = newFace;
			ncards++;
		}
		else
		{
			found = 0;
		}
		
	}

	return newHand;
}

bool fourAces(hand aHand)
{
	int i;
	int numAces = 0;

	for (i=0;i<5; i++)
	{
		if (aHand.cards[i].face == ACE) numAces++;
	}

	if (numAces == 4) return true;

	return false;

}
