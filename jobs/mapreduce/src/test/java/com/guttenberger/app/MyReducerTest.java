package com.guttenberger.app;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapreduce.Reducer;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.util.Arrays;

import static org.mockito.Mockito.*;

public class MyReducerTest {

    @Mock
    private Reducer<Text, IntWritable, Text, IntWritable>.Context context;
    private MyReducer myReducer;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        myReducer = new MyReducer();
    }

    @Test
    public void testReducer() throws IOException, InterruptedException {
        Text inputKey = new Text("test");
        Iterable<IntWritable> inputValues = Arrays.asList(new IntWritable(1), new IntWritable(1));

        myReducer.reduce(inputKey, inputValues, context);

        verify(context, times(1)).write(new Text("test"), new IntWritable(2));
    }
}
