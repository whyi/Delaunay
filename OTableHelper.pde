public class OTableHelper {
  private void swap(ArrayList list, int a, int b) {
    Triplet tmp = (Triplet) list.get(a);
    list.set(a, list.get(b));
    list.set(b, tmp);
  }

  private int partition(ArrayList list, int left, int right) {
    int pivotIndex = floor((left + right)/2);
    final Triplet pivotValue = (Triplet) list.get(pivotIndex);
    swap(list, pivotIndex, right);

    int storedIndex = left;
    for (int i=left; i<right; ++i) {
      Triplet currentValue = (Triplet) list.get(i);
      if (currentValue.isLessThan(pivotValue)) {
        swap(list, storedIndex, i);
        ++storedIndex;
      }
    }
    swap(list, right, storedIndex);
    return storedIndex;
  }
  
  private ArrayList naiveQuickSort(ArrayList list, int left, int right) {
    if (left < right) {
      final int pivot = partition(list, left, right);
      naiveQuickSort(list, left, pivot-1);
      naiveQuickSort(list, pivot+1, right);
    }
    return list;
  }

  public ArrayList naiveSort(ArrayList list) {
    return naiveQuickSort(list, 0, list.size()-1);
  }
}
