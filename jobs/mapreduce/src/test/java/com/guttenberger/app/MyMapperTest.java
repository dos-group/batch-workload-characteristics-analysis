package com.guttenberger.app;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Mapper.Context;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;
import java.io.IOException;

public class MyMapperTest {

    @Mock
    private Context context;
    private MyMapper myMapper;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        myMapper = new MyMapper();
    }

    @Test
    public void testMapper() throws IOException, InterruptedException {
        Text inputKey = new Text();
        Text inputValue = new Text("test");
    
        myMapper.map(inputKey, inputValue, context);
    
        verify(context, times(1)).write(new Text("test"), new IntWritable(1));
    }
    
}
