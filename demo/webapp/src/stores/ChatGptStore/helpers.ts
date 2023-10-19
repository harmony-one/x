export const isPhraseComplete = (text: string, isFirst = false) => {
    const wordsAmount = text.split(' ').length;

    const specSymbols = ['?', '.', '!'];

    if (isFirst) {
        return wordsAmount > 10 || [...specSymbols, ','].some(symbol => text.includes(symbol));
    } else {
        return wordsAmount > 20 || specSymbols.some(symbol => text.includes(symbol));
    }
}
